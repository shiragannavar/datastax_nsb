#!/bin/bash

# remount /home on nvme1n
sudo mke2fs /dev/nvme1n1
sudo e2label /dev/nvme1n1 home
printf "LABEL=home\t/home\text4\tdefaults\t0 2\n" | sudo tee -a /etc/fstab
sudo rsync -av /home/ /_home/
sudo mount /home
sudo rsync -av /_home/ /home/
