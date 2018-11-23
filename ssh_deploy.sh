#!/bin/bash
# Run in local laptop only

SSH_KEY_PATH="D:\tim_projects\gcp\keys\\20181123\appadm.pem"
SSH_USER=appadm
PROJECT_ID="inna-test-project"

export http_proxy=http://127.0.0.1:1080
export https_proxy=http://127.0.0.1:1080
export no_proxy="127.0.0.1, localhost, 192.168.*.*"

app_name="eep16_search_ui"
#echo "Creating temporary tar file for deploymment ..."
#temp_file="/c/temp/${app_name}.tar"
#rm -f "${temp_file}"
#tar --exclude='./venv' --exclude='./.idea' --exclude='./__pycache__' -cf "${temp_file}" .

target_ip=$(gcloud compute instances list --filter="NAME:eep16-ui" --format='[box]' | grep RUNNING | awk -F\| '{print $7}')

#git_cmd="rm -rf /eep16_apps/${app_name}; mkdir -pv /eep16_apps/${app_name}; cd /eep16_apps/${app_name}; tar -xf /eep16_apps/${app_name}.tar; sh conda_start.sh 2>&1 ; exit"
git_cmd="sudo mkdir -pv /eep16_apps/; sudo chown -R appadm:appadm /eep16_apps/; cd /eep16_apps/; rm -rf /eep16_apps/${app_name}; gcloud source repos clone eep16_search_ui --project=${PROJECT_ID}; cd /eep16_apps/${app_name}; sh conda_start.sh 2>&1 ; exit"
for ip in ${target_ip}
do
    echo "Deploying to target: ${ip}"
    #scp -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no "${temp_file}" ${SSH_USER}@${ip}:"/eep16_apps/${app_name}.tar"
    ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=no ${SSH_USER}@${ip} ${git_cmd}
done