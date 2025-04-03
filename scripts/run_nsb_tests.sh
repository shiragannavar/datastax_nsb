#!/bin/bash

local_ip=$(hostname -I | awk '{print $1}')

cd /home/ubuntu/datastax_nsb
if [ $? -ne 0 ]; then
    echo "Failed to change directory to /home/ubuntu/datastax_nsb"
    exit 1
fi
echo "Running a couple no sql bench smoke tests, check the Grafana dashboard for results"
echo "Local IP Address: $local_ip"

/home/ubuntu/datastax_nsb/nb5 cql_starter default host=${local_ip} localdc=dc1
/home/ubuntu/datastax_nsb/nb5 /home/ubuntu/datastax_nsb/test.yaml default host=${local_ip} localdc=dc1 rampup-cycles=1000 main-cycles=100000 rate=1000

