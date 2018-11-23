#!/bin/bash

APP_ROOT="/eep16_apps"
VENV_NAME="eep16-ui"
PYTHON_VERSION="3.7"
UI_PORT=8999

#download_source() {
#    mkdir -pv ${APP_ROOT}
#    cd ${APP_ROOT}
#    git config --global credential.helper gcloud.sh
#    gcloud source repos clone eep16_search_ui --project=wealth-sales-bot
#}

setup_application() {
    . /opt/anaconda3/etc/profile.d/conda.sh
    conda create -y -n ${VENV_NAME} python=${PYTHON_VERSION} anaconda
    # just in case you want to remove the virtual environment:  conda remove -n ${VENV_NAME} --all
    conda activate ${VENV_NAME}
    conda install -y -n ${VENV_NAME} --file ${APP_ROOT}/eep16-ui/requirements.txt
}

kill_process() {
    echo "Check if any existing processes are still running"
    sudo ps -ef | grep flask | grep -v grep
    PID=$(sudo ps -ef | grep flask | grep ${UI_PORT} | grep -v grep | awk '{print $2}')
    for process in $PID
    do
        echo "Killing process ${process}..."
        sudo kill -9 ${process}
    done
}

start_flask_app() {
    cd ${APP_ROOT}/eep16-ui
    export FLASK_APP=flask_app.py
    nohup flask run -h 0.0.0.0 -p ${UI_PORT} --reload --with-threads --debugger &>app.log &
    echo "Flask app is started successfully."
    exit 0
}

# Main
#download_source
export PATH=/opt/anaconda3/bin:${PATH}
sudo mkdir -pv $APP_ROOT
setup_application
kill_process
start_flask_app




