#!/bin/bash


printf "Verifying the environment\n\n"

if lsblk | grep nvme1n1 &> /dev/null; then
    printf "nvme volume is available\n\n"
    lsblk
    echo "Hit enter to continue"
    read dummpty

else
    printf "nvme volumes is NOT available\n"
    printf "Make sure the EC2 instance has 2 EBS volumes \n"
    printf "Press Enter to continue...\n"
    echo "Hit enter to continue"
    read dummpty
fi
