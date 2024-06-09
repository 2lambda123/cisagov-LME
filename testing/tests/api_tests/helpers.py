import json

import requests
from requests.auth import HTTPBasicAuth


def make_request(url, username, password, body=None):
    auth = HTTPBasicAuth(username, password)
    headers = {"Content-Type": "application/json"}

    if body:
        response = requests.post(
            url, auth=auth, verify=False, data=json.dumps(body), headers=headers, 
        timeout=60)
    else:
        response = requests.get(url, auth=auth, verify=False, timeout=60)

    return response


def load_json_schema(file_path):
    with open(file_path, "r") as file:
        return json.load(file)
