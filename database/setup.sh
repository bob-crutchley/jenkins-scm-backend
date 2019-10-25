#! /usr/bin/env bash
# setup a mysql db in a docker container

# install docker if it isn't already
if ! docker --version > /dev/null; then
    curl https://get.docker.com | sudo bash
fi

echo "${MYSQL_ROOT_PASSWORD} ${MYSQL_PASSWORD}"

create_container() {
    sudo docker run -d \
        --name mysql \
        -p 3306:3306 \
        -e MYSQL_DATABASE="bookshelve" \
        -e MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}" \
        -e MYSQL_USER="bookshelve-api" \
        -e MYSQL_PASSWORD="${MYSQL_PASSWORD}" \
        mysql:5.7
}

run_sql_scripts() {
    docker exec -i mysql mysql bookshelve \
        -uroot -p${MYSQL_ROOT_PASSWORD} < setup.sql 
}

# if the container doesn't exist
if [ -z "$(docker ps -qa -f name=mysql)" ]; then
    create_container
# if the container is stopped
elif [ -n "$(docker ps -q -f status=exited -f name=mysql)" ]; then
    docker start mysql
    run_sql_scripts
# the container must be running, so just execute the scripts
else
    run_sql_scripts
fi
