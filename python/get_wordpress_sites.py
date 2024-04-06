import os 
import json

def list_website_directories():
    dir_path = "../bin/wordpress-sites/sites"
    results = []

    for path in os.listdir(dir_path):
        if os.path.isdir(os.path.join(dir_path, path)):
            results.append(path)
    print(json.dumps(results))

list_website_directories()

