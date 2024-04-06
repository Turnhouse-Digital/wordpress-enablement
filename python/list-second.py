import json
import requests
import os
from dotenv import load_dotenv

load_dotenv()

repo_owner = os.getenv("GITHUB_REPO_OWNER")
repo_name = os.getenv("GITHUB_REPO_NAME")
access_token = os.getenv("GITHUB_ACCESS_TOKEN")


def list_html_files(repo_owner, repo_name, access_token, path=""):
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/contents/{path}"
    headers = {
        "Authorization": f"token {access_token}",
        "Accept": "application/vnd.github.v3+json"
    }
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        files = []
        contents = response.json()
        for item in contents:
            if item["type"] == "file" and item["name"].endswith("html"):
                files.append(item["path"])
            elif item["type"] == "dir":
                files.extend(list_html_files(repo_owner, repo_name, access_token, item["path"]))
        return files
    else:
        print(json.dumps({"error": f"Failed to list HTML files: {response.status_code} - {response.json()['message']}"}))
        return []


html_files = list_html_files(repo_owner, repo_name, access_token)
print(json.dumps(html_files, indent=2))
