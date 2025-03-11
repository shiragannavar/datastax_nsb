# datastax_nsb
## Extensions for the no-sql-bench utility

This package allows the user to create and deploy a single node implementation of NOSQLBench
and it's associated apps for testing of DSE (or OSS) clusters.

The script can be execute directly from a target instance, or locally form a mac

This script will install and configure a self contained single nod benchmarking environment
 the deployment contains: 
  - local no-sql-bench install
  - single-node DSE docker container
  - Victoria Metrics docker container
  - Grafana container

## 0. WARNING - Pre-requisites

Before executing either script, you need to provision an EC2 (or other vm) instance and
clone this repo onto the machine. The script assumes you add 2 nvme (Non-Volatile Memory Express) 
volumes. From the vm, type this command to determine what volumes are available

```
lsblk
```

Look for something that looks like

    nvme1n1      259:3    0    200G  0 disk
    nvme2n1      259:4    0    100G  0 disk

## 1. EC2 Provisioning

### Choose an ubuntu flavor - tested with version 22.04

![Ubuntu version](./img/Ubuntu2204.png)

### Choose an instance type - tested with i4, must support nvme devices

![Instance Type](./img/EC2_i4.png)

### Create 2 addtional volumes - use io1 for optimal iops performance

![io1 Volumes](./img/nvme_volumes.png)

## 2. verify things went well
```
./install_nsb_single_node_aws_i4.sh VERIFY
```

## USAGE:

The tool can be used one of two ways:

### Clone repo directly to the target linux vm and run the shell:
```
./nsb_install_ubuntu.sh
```

### Clone repo directly to your local mac and run:
```
./nsb_install_from_mac.sh
```

For the local MAC run, you will need the following info:

```
PEM_FILE='/Users/bob.hardaway/work/install/validkey.pem'
EC2_Host='ec2-52-53-171-73.us-west-1.compute.amazonaws.com'
USER=ubuntu
```


## 4. Steps required once script completes

 - Open ports 8428, 3000, 9042 on the AWS security group
 - Connect to Victoria Metric UI at http://<ip>:8428 
 - Connect to Grafana at http://<ip>:3000 and: 
   - Create a prometheus datasource in Grafana - NOTE determine and use the private ip for the docker process:
        - to determine that ip, use ifconfig and look for the settings for the docker0 interface. will look something like
           - docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
           - inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
   - create an service account and api token in the grafana UI - NOTE, make sure to give the SA admin rights
      this token is added to a ~/.nosqlbench/grafana file you create
   -  create or import included dashboard - the example dashboard is setup using 'prometheus' as the 
       datasource name, which is the default in grafana. If you choose a different datasource name, you
       will need to replace the name 'prometheus' in the example dashboard json file.

### Access AWS Console, navigate to your vm, click the security tab and add 3 new rules

![Instance Type](./img/AWSSecurityGroup.png)
![Instance Type](./img/Add3Rules.png)

### Create a new Prometheus Connection
#### NOTE: Leave the default name 'prometheus' if you change this the nsb config must be changed
####  The IP here must be the local IP the Docker container is running on, you can check this by
####   typing this command in the vm: 
####            ifconfig
####   and look for the IP under the section docker

![Connection URL](./img/ConnectionIP.png)

### Test and Save the string

![Save and Test](./img/ProSaveandTest.png)

### Create a Service Account.

![Save and Test](./img/SAAdd.png)
![Save and Test](./img/ServiceAccountADMIN.png)

### Create a Token for the account. Copy n Paste the token
###  you can run the set_grafana_apikey.sh script to set this value in the VM

![Save and Test](./img/TokenCopy.png)

### Import the sample Dashboard. Import button is at the top-right in Grafana UI.
### You may encounter a bug with import, if you do just copy/paste the json

![Save and Test](./img/DashUpload.png)
![Save and Test](./img/DashImportRight.png)
![Save and Test](./img/AwSnap.png)
![Save and Test](./img/DashImport.png)

### Run the helper script and enter the api key generated in grafana 

```
> ./set_grafana_apikey.sh
Enter token value:
```



## 4. Nosqlbench smoke tests:

```
> ./run_nsb_tests.sh
```

#### This will execute the builtin cql_starter test as well as the test included in the test.yaml file
#### Check the nosqlbench doc for more on test execution

### Visit the grafana UI Dashboard to see stats. NOTE: It takes 30sec or more for the dashboard to 
### update once a test is run.
