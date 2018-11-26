# EEP16 assignment UI

# Environment setup:
sudo yum install -y wget bzip2 git

cd /tmp

wget https://repo.anaconda.com/archive/Anaconda3-5.3.1-Linux-x86_64.sh

bash Anaconda3-5.3.1-Linux-x86_64.sh -b -f -p /opt/anaconda3 -u

After that, refer to conda_start.sh

# Accessing the application:
http://eep16.fcr-it.top:8999/

# ElasticSearch install
sudo yum install -y java telnet wget unzip
edit .bas_profile for JAVA_HOME variable
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.1.tar.gz
sudo rpm -ivh elasticsearch-6.5.1.rpm
sudo systemctl enable elasticsearch.service

ElasticSearch security in elasticsearch.yml:
script.disable_dynamic: true
script.allowed_contexts: none
script.allowed_types: none


# Mount google storage for fscrawler to scan the documents

Install gcfuse first:
https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/installing.md

sudo tee /etc/yum.repos.d/gcsfuse.repo > /dev/null <<EOF
[gcsfuse]
name=gcsfuse (packages.cloud.google.com)
baseurl=https://packages.cloud.google.com/yum/repos/gcsfuse-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo yum update
sudo yum install gcsfuse


sudo mkdir -pv /fscrawler-mount
sudo chown appadm:appadm /fscrawler-mount/
sudo umount --force --lazy /fscrawler-mount
export bucket_name=fscrawler-mount-eep16
gcsfuse --dir-mode 755 ${bucket_name} /fscrawler-mount

# Fscrawler install
wget https://repo1.maven.org/maven2/fr/pilato/elasticsearch/crawler/fscrawler/2.5/fscrawler-2.5.zip
unzip fscrawler-2.5.zip

(Create the fscrawler setting by running this command:  the config file will be in "/home/appadm/.fscrawler/eep16/_settings.json")
/home/appadm/fscrawler-2.5/bin/fscrawler eep16
(then edit the json config to change url to the /fscrawer-mount/)

mkdir -pv /home/appadm/fscrawler-2.5/logs
nohup /home/appadm/fscrawler-2.5/bin/fscrawler eep16 >> /home/appadm/fscrawler-2.5/logs/fscrawler.log &

(for restart only：)
nohup /home/appadm/fscrawler-2.5/bin/fscrawler eep16 --loop 1 --restart >> /home/appadm/fscrawler-2.5/logs/fscrawler.log & 

# SSL preparation: (deprecated)
openssl genrsa -out eep16.fcr-it.top.key 2048
openssl req -new -key eep16.fcr-it.top.key -out eep16.fcr-it.top.csr
openssl x509 -req -days 1095 -in eep16.fcr-it.top.csr -signkey eep16.fcr-it.top.key -out eep16.fcr-it.top.crt