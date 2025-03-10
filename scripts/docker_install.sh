#!/bin/bash

# Ensure the script is run on Ubuntu Linux
if ! grep -q "Ubuntu" /etc/os-release; then
    echo "This script must be run on Ubuntu Linux."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_SUSPEND=1

SETHOSTNAME=${SETHOSTNAME:my-nsb-node}
# Do this if you know the name
sudo hostnamectl set-hostname "${SETHOSTNAME}"

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

# put /var/lib/docker on nvme2n
sudo mke2fs /dev/nvme2n1
sudo e2label /dev/nvme2n1 docker
sudo mkdir -p /var/lib/docker
printf "LABEL=docker\t/var/lib/docker\text4\tdefaults\t0 2\n" | sudo tee -a /etc/fstab
sudo mount /var/lib/docker

# maybe missing packages
sudo DEBIAN_FRONTEND=noninteractive apt install -y jq net-tools sysstat htop curl

# remove conflicting packages for docker
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc
 do sudo DEBIAN_FRONTEND=noninteractive apt-get remove $pkg
done
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
 $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
 | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y vim netdata

# verify sane docker install
sudo docker run --rm hello-world

# ubuntu user can manage docker
sudo usermod -G docker ubuntu

# make memory mapping work with large java heaps
echo "vm.max_map_count = 256000" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p /etc/sysctl.conf

## get and run docker images for DSE, Victoriametrics, and Grafana
sudo docker run -e DS_LICENSE=accept --name my-dse -p 9042:9042 -d datastax/dse-server:6.9.5

sudo docker run -d -v /home/ubuntu/victoria-metrics-data:/victoria-metrics-data -p 8428:8428 --network=host victoriametrics/victoria-metrics

sudo docker run -d --name=grafana -p 3000:3000 grafana/grafana

echo ""
echo "Setup complete!"
echo ""

echo "Next steps - aka things you can't do in the script:"
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
