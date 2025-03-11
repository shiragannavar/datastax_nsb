#!/bin/bash


printf "Verifying the environment\n\n"

if df -h | grep nvme &> /dev/null; then
    printf "nvme volume is available\n\n"
    df -h
    echo "Hit enter to continue"
    read dummpty

else
    printf "nvme volumes is NOT available\n"
    printf "Make sure the EC2 instance has 2 EBS volumes \n"
    printf "Press Enter to continue...\n"
    echo "Hit enter to continue"
    read dummpty
fi
