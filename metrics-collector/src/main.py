import subprocess
import boto3
import json
import os
from botocore.vendored import requests
import datetime as DT
from dateutil import parser



output = {}
output.setdefault("lists", [])

dynamodb = boto3.resource('dynamodb', region_name='us-east-1', endpoint_url="https://dynamodb.us-east-1.amazonaws.com")


def get_pids():
    table = dynamodb.Table(os.environ['DB_TABLE_NAME'])
    response = table.scan()['Items']
    project_ids = []
    for item in response:
        project_ids.append(item['GitlabProjectId'])
    return project_ids

def get_project_details(project_id):
    table = dynamodb.Table(os.environ['DB_TABLE_NAME'])
    response = table.get_item(Key={'GitlabProjectId': project_id})
    return response['Item']



def main():
    # Fetching all the projects id's available in the dynamodb database
    pids = get_pids()
    for project_id in pids:
        response = get_project_details(project_id)
        failed = []
        success = []
        pending = []
        base_url = "https://gitlab.healthcareit.net/api/v4"
        get_project = "/projects/" + project_id
        if (os.environ.get('GITLAB_TOKEN_SECRET_NAME') == None):
            session = boto3.session.Session()
            client = session.client("secretmanager","us-east-1")
            get_secret_value = client.get_secret_value(SecretId="imncore/dev/cicd/gitlab_token")
            secret = get_secret_value['SecretString']
        else:
            secret = os.environ.get('GITLAB_TOKEN_SECRET_NAME')
        token = "?private_token="+secret
        # Fetching the single project details
        get_project_details_by_api = base_url + get_project + token
        proc = subprocess.Popen(['curl', get_project_details_by_api], stdout=subprocess.PIPE)
        (project_out, err) = proc.communicate()
        project_out = json.loads(project_out)
        # Fetching the pipelines related to the project we fetched above
        get_pipeline = "/projects/" + project_id + "/pipelines"
        get_pipelinesby_api = base_url + get_pipeline + token
        proc = subprocess.Popen(['curl', get_pipelinesby_api], stdout=subprocess.PIPE)
        pipelines_out, err = proc.communicate()
        parsed = json.loads(pipelines_out)
        # Fetching the Project Jobs for the final JSON Structure
        get_project_jobs_from_api = base_url + get_project + "/jobs" + token
        proc = subprocess.Popen(['curl', get_project_jobs_from_api], stdout=subprocess.PIPE)
        (project_jobs, err) = proc.communicate()
        project_jobs = json.loads(project_jobs)
        final = {}
        final.setdefault('result', [])
        today = DT.date.today()
        for item in parsed:
            week_ago = today - DT.timedelta(days=7)
            try:
                # Checking if the pipeline created date in between the current date and 7 days prior
                if (week_ago < parser.parse(item['created_at']).date() < today) == True:
                    pipeline_id = item['id']
                    # Fetching the jobs for the pipelines created before 7 days from today
                    get_pipeline_variables_by_api = base_url + get_project + "/pipeline/" + str(pipeline_id) + "/variables" + token
                    proc = subprocess.Popen(['curl', get_project_details_by_api], stdout=subprocess.PIPE)
                    (pipeline_variables, err) = proc.communicate()
                    pipeline_variables = json.loads(pipeline_variables)
                    deployment_status = item['status']
                    pipeline_created_time = item['created_at']
                    # Fetching the pipeline variables
                    get_jobs = "/projects/" + project_id + "/pipelines/" + str(pipeline_id) + "/jobs"
                    get_jobs_api = base_url + get_jobs + token
                    proc = subprocess.Popen(['curl', get_jobs_api], stdout=subprocess.PIPE)
                    (jobs_out, err) = proc.communicate()
                    jobs = json.loads(jobs_out)
                    # Getting the Job Numbers Required
                    total = len(jobs)
                    success = []
                    failed = []
                    pending = []
                    blocked = []
                    #Running through each job in the single pipeline
                    for item in jobs:
                        if item['status'] == "success":
                            success.append(item)
                        elif item['status'] == "failed":
                            failed.append(item)
                        elif item['status'] == "pending":
                            pending.append(item)
                        elif item['status'] == "blocked":
                            blocked.append(item)
                        print("No. of Failed Jobs:", len(failed))
                        print("no. of Success Jobs:", len(success))
                        print("no. of pending Jobs:", len(pending))
                        output = {
                            "team": response['PlatformTeamName'], \
                            "project_id": project_id, \
                            "project_path": response['GitlabProjectPath'], \
                            "pipeline_id": str(pipeline_id), \
                            "job_count": len(jobs), \
                            "successful_jobs": len(success), \
                            "pending_jobs": len(pending), \
                            "failed_jobs": len(failed), \
                            "stage": 'dev', \
                            "deployment_status": deployment_status, \
                            "pipeline_created": pipeline_created_time, \
                            "gitlab_project": project_out, \
                            "gitlab_pipeline_variables": pipeline_variables, \
                            "gitlab_jobs": project_jobs
                        }
                        final['result'].append(output)
                        post_url = os.environ['DEVOPS_VPC_DASHBOARD_ENDPOINT']+"/platform_build_metrics/files"
                        headers = {
                            "Content-Type": "application/json"
                        }
                        payload = json.dumps(output)
                        print("\n Inserting \n")
                        # Inserting in Elastic Search
                        answer = requests.post(post_url, data=payload, headers=headers)
                        print(answer.status_code)
                        print("\n\n Inserted \n\n")
            except:
                continue
    return final['result']


def handler(event, context):
    main()