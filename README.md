# datastax_nsb
## Extensions for the no-sql-bench utility

This package allows the user to create and deploy a single node implementation of NOSQLBench
and it's associated apps for testing of DSE (or OSS) clusters.


This script will install and configure a self contained single nod benchmarking environment
 the deployment contains: 
  - local no-sql-bench install
  - single-node DSE docker container
  - Victoria Metrics docker container
  - Grafana container

## Node setup:

<ol>
  <li>chmod +x install_nsb_single_node_aws_i4.sh</li>
  <li>./install_nsb_single_node_aws_i4.sh INSTALL</li>
  <li>./install_nsb_single_node_aws_i4.sh VERIFY</li>
</ol>
>
## Next steps - aka things you can't do in the script:

 - Open ports 8428, 3000, 9042 on the AWS security group
 - Connect to Victoria Metric UI at http://<ip>:8428 
 - Connect to Grafana at http://<ip>:3000 and: 
   - Create a prometheus datasource in Grafana - NOTE determine and use the private ip for the docker process:
        - to determine that ip, use ifcinfig and look for the settings for the docker0 interface. will look something like
           docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
           inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
   - create an service account and api token in the grafana UI - NOTE, make sure to give the SA admin rights
      this token is added to a ~/.nosqlbench/grafana file you create
   -  create or import included dashboard - the example dashboard is setup using 'prometheus' as the 
       datasource name, which is the default in grafana. If you choose a different datasource name, you
       will need to replace the name 'prometheus' in the example dashboard json file.

## EC2 Provision

### Choose an unbuntu flavor - tested with 22.04

![Ubuntu version](./img/Ubuntu2204.png)

### Choose an instance type - tested with i4, must support nvme devices

![Instance Type](./img/EC2_i4.png)

### Create 2 addtional volumes

![io1 Volumes](./img/nvme_volumes.png)

## Steps required once script completes

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

### Use the api key generated here and run the helper script to set in the vm

```
> ./set_grafana_apikey.sh
Enter token value:
```

## Nosqlbench examples:
   - Replace localIP with the local ip address of your vm

> sudo ./nb5 cql_starter default.schema host=<localIP> localdc=dc1
> sudo ./nb5 test.yaml default host=<localIP> localdc=dc1 rampup-cycles=1000 main-cycles=400000
