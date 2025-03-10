#!/bin/bash


printf "Verifying the environment\n\n"

if sudo docker ps &> /dev/null; then
    printf "Docker is installed and running\n\n"
else
    printf "Docker is not installed or not running\n"
fi

if sudo docker exec -it my-dse nodetool status &> /dev/null; then
    printf "DSE is installed and running\n\n"
else
    printf "DSE is not installed or not running\n"
fi

if df -h | grep nvme &> /dev/null; then
    printf "nvme volumes are mounted\n\n"
else
    printf "nvme volumes are not mounted\n"
fi

if sudo ./nb5 --list-scenarios &> /dev/null; then
    printf "No-SQL-Bench is installed and running\n\n"
else
    printf "No-SQL-Bench is not installed or not running\n"
fi
