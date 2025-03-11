#!/bin/bash

echo 'Log onto the Grafana UI and create an API key for the Service Account'
echo 'then'
echo "Enter that grafana api key you created in the UI for the Service Account:"
read apikey

echo "${apikey}" > /home/ubuntu/datastax_nsb/.nosqlbench/grafana/grafana_apikey
