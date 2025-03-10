#!/bin/bash


printf "Verifying the environment\n\n"

if df -h | grep nvme &> /dev/null; then
    printf "nvme volumes is available\n\n"
else
    printf "nvme volumes is NOT available\n"
    printf "Make sure the EC2 instance has 2 EBS volumes \n\n"

    read -p "Press Enter to continue..."

fi
