# EEP16 assignment UI

* Environment setup:
sudo yum install -y wget bzip2 git
cd /tmp
wget https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh
bash Anaconda3-5.3.1-Linux-x86_64.sh -b -f -p /opt/anaconda3 -u

After that, refer to conda_start.sh

* Startup the application:
./start.sh

* Accessing the application:
https://tim-jupyter.fcr-it.top:8999/

* SSL preparation:
openssl genrsa -out tim-jupyter.fcr-it.top.key 2048
openssl req -new -key tim-jupyter.fcr-it.top.key -out tim-jupyter.fcr-it.top.csr
openssl x509 -req -days 1095 -in tim-jupyter.fcr-it.top.csr -signkey tim-jupyter.fcr-it.top.key -out tim-jupyter.fcr-it.top.crt