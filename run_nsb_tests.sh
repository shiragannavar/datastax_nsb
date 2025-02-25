#!/bin/bash

local_ip=$(hostname -I | awk '{print $1}')

echo "Running a couple no sql bench smoke tests"
echo "Local IP Address: $local_ip"

sudo ./nb5 cql_starter default.schema host=${local_ip} localdc=dc1
sudo ./nb5 test.yaml default host=${local_ip} localdc=dc1 rampup-cycles=1000 main-cycles=400000

