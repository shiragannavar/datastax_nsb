#!/bin/bash

echo "Enter the grafana api key you created in the UI for the Service Account:"
read -r apikey

echo "${apikey}" > /home/ubuntu/datastax_nsb/.nosqlbench/grafana/grafana_apikey
