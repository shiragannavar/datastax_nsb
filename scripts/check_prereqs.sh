#!/bin/bash


printf "Verifying the environment\n\n"

if df -h | grep nvme &> /dev/null; then
    printf "nvme volume is available\n\n"
    read -p 
else
    printf "nvme volumes is NOT available\n"
    printf "Make sure the EC2 instance has 2 EBS volumes \n"
    printf "Press Enter to continue...\n"
    read -p 

fi
