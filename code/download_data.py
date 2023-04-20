import subprocess
import json
from collections import Counter
import os

"""Use the Box API to download the zipped folders in a nested directory structure"""
def run_cmd(command):
    result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, shell=True)
    print(f"Command Exited with {result.returncode} status.")
    return result.stdout.strip()

def get_folder(id):
    return json.loads(run_cmd(f"box folders:items {id} --json"))

def flatten_nested_list(list):
    list_flat = []
    for sub_list in list:
        for item in sub_list:
            list_flat.append(item)
    return list_flat
    
def filter_keys(list_of_dicts):
    keys_to_keep = {"name", "id", "type", "parent"}
    return [{key: value for key, value in d.items() if key in keys_to_keep} 
            for d in list_of_dicts]
    
def download_data(id, dest):
    run_cmd(f'box files:download {id} --destination {dest} --no-overwrite')


if __name__ == '__main__':
    
    os.chdir(os.path.join(os.path.dirname(__file__), '..'))
    if not os.path.exists('data'):
            os.mkdir('data')
    
    if not os.path.exists('contents.json'):
     # set wd
        CAVS_DIR_ID = '198801056006' # ID in Box
        dirs = get_folder(CAVS_DIR_ID)

        #subdirs = [json.loads(run_cmd(f"box folders:items {dir['id']} --json")) for dir in dirs]
        subdirs = [get_folder(d['id']) for d in dirs]

        # get subdir lengths for later
        subdirs_lengths = [len(d) for d in subdirs]
        Counter(subdirs_lengths) # print tally

        subdirs_flat = filter_keys(flatten_nested_list(subdirs))
        subdirs_filtered = [d for d in subdirs_flat if d['type'] == 'folder']

        # filter dictionaries for easier reading
        contents = [[{**c, 'parent': d['name']} for c in get_folder(d['id'])] for d in subdirs_filtered]
        contents_flat = filter_keys(flatten_nested_list(contents))
        
        # save before moving on
        with open('contents.json', 'w') as f:
            json.dump(contents_flat, f)
            
        contents_filtered = [d for d in  contents_flat if d['name'] == 'raw_data.zip']

    else: 
        with open ('contents.json', 'r') as f:
            contents_flat = json.load(f)
        contents_filtered = [d for d in  contents_flat if d['name'] == 'raw_data.zip']

    for c in contents_filtered:

        dirname = f'data/{c["parent"]}'
        if not os.path.exists(dirname):
            os.mkdir(dirname)
        
    [download_data(c['id'], f"data/{c['parent']}") for c in contents_filtered if not os.path.exists(f"data/{c['parent']}/{c['name']}")]
        # run_cmd(f'box files:download {c["id"]} --destination {dirname}')
