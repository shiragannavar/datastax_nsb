#!/bin/bash

echo "Enter the grafana api key you created in the UI for the Service Account:"
read apikey

echo "${apikey}" > .nosqlbench/grafana/grafana_apikey
