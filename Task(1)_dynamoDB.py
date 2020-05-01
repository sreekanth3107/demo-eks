import sys, os
import gitlab
import json
import boto3
import subprocess
from botocore.exceptions import ClientError


gl = gitlab.Gitlab("https://gitlab.healthcareit.net","nU7gFuzFopvdLTJzPLj1")
client = boto3.client('dynamodb', region_name='us-east-1', endpoint_url="https://dynamodb.us-east-1.amazonaws.com")
dynamodb = boto3.resource('dynamodb', region_name="us-east-1", endpoint_url="https://dynamodb.us-east-1.amazonaws.com")

def get_project_details(project_id):
    project  = gl.projects.get(str(project_id))
    print("Project "+str(project)+" details fetched")
    result = {
        "GitlabProjectId": project.id, \
        "GitlabProjectPath": project.path_with_namespace
    }
    print(result)
    return result
def verify_table_exists(table_name):
    table = dynamodb.Table(table_name)
    try:
        response = client.describe_table(TableName=table_name)
    except ClientError as ce:
        if ce.response['Error']['Code'] == 'ResourceNotFoundException':
            print ("Table " + table_name + " does not exist. Create the table first and try again.")
            print("Creating table")
            subprocess.call(['terraform', 'init'])
            subprocess.call(['terraform', 'apply'])
            print("Table "+table_name+" Created")
        else:
            print("Unknown exception occurred while querying for the " + table_name + " table. Printing full error:")
            print(ce.response)
    return table_name

def insert_into_ddb(project_id, table_name):
    table =dynamodb.Table(table_name)
    project = get_project_details(project_id)
    GitlabProjectId = project['GitlabProjectId']
    GitlabProjectPath = project['GitlabProjectPath']
    table.put_item(
        Item={
            "GitlabProjectId":str(GitlabProjectId),
            "GitlabProjectPath":GitlabProjectPath
        }
    )


if __name__ == "__main__":
    project_id = sys.argv[1]
    table_name = "imncore-dev-dynamodb-hashes"
#    verify_table_exists(table_name)
    insert_into_ddb(project_id, table_name)