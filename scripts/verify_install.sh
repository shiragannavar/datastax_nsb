#!/bin/bash


printf "Verifying the environment\n\n"

if docker ps &> /dev/null; then
    printf "Docker is installed and running\n\n"
else
    printf "Docker is not installed or not running\n"
fi

if docker exec -it my-dse nodetool status &> /dev/null; then
    printf "DSE is installed and running\n\n"
else
    printf "DSE is not installed or not running\n"
fi

if df -h | grep nvme &> /dev/null; then
    printf "nvme volumes are mounted\n\n"
else
    printf "nvme volumes are not mounted\n"
fi

if /home/ubuntu/datastax_nsb/nb5 --list-scenarios &> /dev/null; then
    printf "No-SQL-Bench is installed and running\n\n"
else
    printf "No-SQL-Bench is not installed or not running\n"
fi

echo ""
echo "If the responses are good, setup is complete"
echo ""

echo "Hit enter to continue"
read dummpty

echo ""
echo "Next steps - aka things you can't do in a script:"
echo " - Open these ports 8428, 3000, 9042 on the AWS security group"
echo " - Connect to Victoria Metric UI at http://${pub_ip}:8428 "
echo "   - nothing needs to be set here, but you can see the metrics"
echo " - Connect to Grafana at http://${pub_ip}:3000 and: "
echo "   - Create a prometheus datasource in Grafana - NOTE determine and use the private ip for the docker process:"
echo "        - use the default datasource name: prometheus"
echo "        - to determine that ip, use ifconfig and look for the settings for the docker0 interface. will look something like"
echo "           docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500"
echo "           inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255"
echo "            so 172.17.0.1 is the address to use in the prometheus data source setup. when you save/test this value it should"
echo "              turn green"
echo "   - Under Admin / Users and access, create an service account and api token in the grafana UI - NOTE, make sure to give "
echo "      the SA admin rights. this token is added to a file named grafana_apikey in the ~/.nosqlbench/grafana folder"
echo "   -  create or import included dashboard - NOTE: the example dashboard assumes the default datasource name: prometheus"
echo ""