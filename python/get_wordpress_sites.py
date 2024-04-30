import os 
import sys
import json

def list_website_directories():
    dir_path = "../bin/wordpress-sites/sites"
    results = {}

    for path in os.listdir(dir_path):
        if os.path.isdir(os.path.join(dir_path, path)):
            results[path] = path  # Use directory name as value

    # json_data = json.dumps(results)
    # sys.stdout.write(json_data)
    sys.stdout.write(json.dumps(results))

list_website_directories()