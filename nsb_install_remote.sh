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

PEM_FILE='/Users/bob.hardaway/work/install/bobhdsedemokey.pem'
EC2_Host='ec2-3-101-21-135.us-west-1.compute.amazonaws.com'
USER=ubuntu

echo 'push the install package to target host'
scp -i "$PEM_FILE" nsb_installer.tar.gz "$USER@$EC2_Host:~/"
ssh -i "$PEM_FILE" "$USER@$EC2_Host" 'tar -xvf nsb_installer.tar.gz'
ssh -i "$PEM_FILE" "$USER@$EC2_Host" 'cd datastax_nsb ; ls -l'

while true; do

    echo ''
    echo 'Which steps do you want to execute?'
    echo ' 1. Check prerequisites'
    echo ' 2. Install NoSQLBench and Grafana/Victoria containers'
    echo ' 3. Remount Docker home on nvme partition'
    echo ' 4. Verify Installation'
    echo ' 5. Set grafana key value'
    echo ' 6. Run NoSQLBench smoke tests'
    echo ' 7. Exit'
    echo ''
    read -p 'Enter the number of the step you want to execute: ' step

    case $step in
    1)
        echo 'Checking prerequisites'
        COMMAND='./datastax_nsb/scripts/check_prereqs.sh'
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
        COMMAND='./datastax_nsb/scripts/verify_install.sh'
        ;;
    5)
        echo 'Set the grafana api key value'
        COMMAND='./datastax_nsb/scripts/set_grafana_api_key.sh'
        ;;
    6)
        echo 'Running NoSQLBench smoke tests'
        COMMAND='./datastax_nsb/scripts/run_smoke_tests.sh'
        ;;
          7)
            echo 'Exiting...'
            exit 0
            ;;
    *)
        echo 'Invalid step'
        exit 1
        ;;
    esac

    ssh -i "$PEM_FILE" "$USER@$EC2_Host" "$COMMAND"
done

echo 'Done'