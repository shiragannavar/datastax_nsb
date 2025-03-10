#!/bin/bash

echo ""
echo "get nosqlbench"

curl -L -O https://github.com/nosqlbench/nosqlbench/releases/latest/download/nb5 > /home/ubuntu/datastax_nsb/nb5
chmod u+x /home/ubuntu/datastax_nsb/nb5/nb5

sudo DEBIAN_FRONTEND=noninteractive add-apt-repository -y universe
sudo DEBIAN_FRONTEND=noninteractive apt install -y libfuse2

echo "Lastly lets create the argsfile for the DSE scenario"
echo "Enter the public dns name of the EC2 instance - example ec2-54-153-54-249.us-west-1.compute.amazonaws.com: "
read pub_ip

echo '--add-labels "instance:dsedocker"' > ./datastax_nsb/.nosqlbench/argsfile
echo "--annotators [{'type':'log','level':'info'},{'type':'grafana','baseurl':'http://${pub_ip}:3000'}]" >> ./datastax_nsb/.nosqlbench/argsfile
echo "--report-prompush-to http://${pub_ip}:8428/api/v1/import/prometheus/metrics/job/nosqlbench/instance/dsedocker" >> ./datastax_nsb/.nosqlbench/argsfile
