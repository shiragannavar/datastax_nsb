#!/bin/bash

# Check if the operating system is macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "This script must be run on macOS."
    exit 1
fi

echo 'Provide connection info for the target host'
echo ''
read -p 'Enter the path to the PEM file: ' PEM_FILE
read -p 'Enter the EC2 Host: ' EC2_Host
read -p 'Enter the user: ' USER



PEM_FILE='/Users/bob.hardaway/work/poc/mc/bobh_mc_poc_key.pem'
EC2_Host='ec2-3-101-21-135.us-west-1.compute.amazonaws.com'
USER=ubuntu


echo 'push the install package to target hist'
scp -i $PEM_FILE nsb_installer.tar.gz $USER@$EC2_Host:~/
ssh -i $PEM_FILE $USER@$EC2_Host 'tar -xvf nsb_installer.tar.gz'
ssh -i $PEM_FILE $USER@$EC2_Host 'cd nsb_installer'


PEM_FILE='/Users/bob.hardaway/work/poc/mc/bobh_mc_poc_key.pem'
EC2_Host=''
USER=ubuntu

echo 'push the install package to target host'
scp -i "$PEM_FILE" nsb_installer.tar.gz "$USER@$EC2_Host:~/"
ssh -i "$PEM_FILE" "$USER@$EC2_Host" 'tar -xvf nsb_installer.tar.gz'
ssh -i "$PEM_FILE" "$USER@$EC2_Host" 'cd nsb_installer'

echo 'Which steps do you want to execute?'
echo ' 1. Check prerequisites'
echo ' 2. Install NoSQLBench and Grafana/Victoria containers'
echo ' 3. Remount Docker home on nvme partition'
echo ' 4. Verify Installation'
echo ' 5. Set grafana key value''
echo ' 6. Run NoSQLBench smoke tests'
echo ''
read -p 'Enter the number of the step you want to execute: ' step

case $step in
  1)
    echo 'Checking prerequisites'
    COMMAND='./check_prereqs.sh'
    ;;
  2)
    echo 'Installing NoSQLBench and Grafana/Victoria containers'
    COMMAND='echo "Installing"'
    ;;
  3)
    echo 'Remounting Docker home on nvme partition'
    COMMAND='echo "remounting"'
    ;;
  4)
    echo 'Verifying Installation'
    COMMAND='./verify_install.sh'
    ;;
  5)
    echo 'Set the grafana api key value'
    COMMAND='echo "Running nsb tests"'
    ;;
  6)
    echo 'Running NoSQLBench smoke tests'
    COMMAND='echo "Running nsb tests"'
    ;;
  *)
    echo 'Invalid step'
    exit 1
    ;;
esac

ssh -i "$PEM_FILE" "$USER@$EC2_Host" "$COMMAND"

echo 'Which steps do you want to execute?'
echo ' 1. Check prerequisites'
echo ' 2. Install NoSQLBench and Grafana/Victoria containers'
echo ' 3. Remount Docker home on nvem partition'
echo ' 4. Verify Installation'
echo ' 5. Run NoSQLBench smoke tests'
echo ''
read -p 'Enter the number of the step you want to execute: ' step

case $step in
  1)
    echo 'Checking prerequisites'
    COMMAND='sudo apt-get update && sudo apt-get install -y openjdk-8-jdk'
    ;;
  2)
    echo 'Installing NoSQLBench and Grafana/Victoria containers'
    COMMAND='sudo docker run -d --name grafana -p 3000:3000 grafana/grafana'
    ;;
  3)
    echo 'Remounting Docker home on nvem partition'
    COMMAND='sudo service docker stop && sudo mv /var/lib/docker /nvme/docker && sudo ln -s /nvme/docker /var/lib/docker && sudo service docker start'
    ;;
  4)
    echo 'Verifying Installation'
    COMMAND='java -version'
    ;;
  5)
    echo 'Verifying Installation'
    COMMAND='sudo ./nb5 cql_starter default.schema host=${local_ip} localdc=dc1'
  *)
    echo 'Invalid step number'
    exit 1
    ;;
esac

COMMAND='java -version'

## run the install scripts on the target machine

ssh -i $PEM_FILE $USER@$EC2_Host $COMMAND



