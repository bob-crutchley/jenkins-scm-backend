#! /usr/bin/env bash
# setup python flask server

app_name=jenkins-scm-backend

# create server user if they don't exist
if cat /etc/passwd | awk -F: '{ print $1}' | grep ${app_name}; then
    sudo useradd -m -s /bin/bash ${app_name}
fi

# make sure python and pip are installed
sudo apt install -y python3 python3-pip

# configure systemd service
service_environment=(
    "s/{{MYSQL_HOST}}/${MYSQL_HOST}/g;"
    "s/{{MYSQL_DATABASE}}/${MYSQL_DATABASE}/g;" 
    "s/{{MYSQL_USER}}/${MYSQL_USER}/g;" 
    "s/{{MYSQL_PASSWORD}}/${MYSQL_PASSWORD}}/g;" 
)
sed  "$(IFS=; echo "${service_environment[*]}")" ${app_name}.service | \
    sudo tee /etc/systemd/system/${app_name}.service

# install folder
install_folder=/opt/bookshelve-server
for file in app.py wsgi.py requirements.txt; do
    cp ${file} ${install_folder}
done

# install dependencies
cd ${install_folder}
pip install -r requirements.txt
