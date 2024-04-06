import json
import requests
import os
from dotenv import load_dotenv

load_dotenv()

repo_owner = os.getenv("GITHUB_REPO_OWNER")
repo_name = os.getenv("GITHUB_REPO_NAME")
access_token = os.getenv("GITHUB_ACCESS_TOKEN")

def list_html_files(repo_owner, repo_name, access_token):
    url =f"https://api.github.com/repos/{repo_owner}/{repo_name}/contents"
    headers = {
        "Authorization": f"token {access_token}",
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        files=[file["name"] for file in response.json() if file["type"] == "file" and file["name"].endswith("html")]
        print(json.dumps(files))
    else:
        print(json.dumps({"error": f"Failed to list HTML files: {response.status_code} - {response.json()['message']}"}))

html_files = list_html_files(repo_owner, repo_name, access_token)
print(json.dumps(html_files, indent=2))
