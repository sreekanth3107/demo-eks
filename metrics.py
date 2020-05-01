import gitlab
import json
import jsonpickle


gl = gitlab.Gitlab("https://gitlab.healthcareit.net","nU7gFuzFopvdLTJzPLj1")

project_id = "12343"
output = {}
output.setdefault("lists",[])


def set_default(obj):
    if isinstance(obj, set):
        return list(obj)
    raise TypeError
	
def get_jobs_from_project(project_id):
    project = gl.projects.get(project_id)
	
    pipelines = project.pipelines.list()
    for every in pipelines:
        jobs = every.jobs.list()
        for each in jobs:
            print(each, type(each),"\n")
            output['lists'].append({each})
    return output

filename = str(project_id)+".json"
with open(filename,"a") as file:
	result = get_jobs_from_project(project_id)
	frozen = jsonpickle.encode(result)
	print(type(frozen))
	json.dump(frozen, file)