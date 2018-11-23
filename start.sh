#!/bin/bash

APP_PATH=/eep16_apps/search_engine_ui
VENV_PATH=${APP_PATH}/venv

setup_application() {
    mkdir -pv ${APP_PATH}
    if [ -d ${VENV_PATH} ]
    then
        echo "Using existing virtual environment: ${VENV_PATH}"
    else
        echo "Creating new virtual environment: ${VENV_PATH}"
        python3 -m virtualenv ${VENV_PATH}
    fi
    . ${VENV_PATH}/bin/activate
    python3 -m pip install -r ${APP_PATH}/requirements.txt
}

kill_process() {
    echo "Check if any existing processes are still running"
    sudo ps -ef | grep flask | grep tim-jupyter.fcr-it.top | grep -v grep
    PID=$(sudo ps -ef | grep flask | grep tim-jupyter.fcr-it.top | grep -v grep | awk '{print $2}')
    for process in $PID
    do
        echo "Killing process ${process}..."
        sudo kill -9 ${process}
    done
}

# Main

setup_application
kill_process

cd ${APP_PATH}
export FLASK_APP=flask_app.py
nohup flask run -h 0.0.0.0 -p 8999 --reload --with-threads --cert tim-jupyter.fcr-it.top.crt --key tim-jupyter.fcr-it.top.key --debugger &
