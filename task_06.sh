#!/bin/bash
source task_01.sh
source task_02.sh

which curl > /dev/null || sudo apt-get install curl && {
    rm -f index.html > /dev/null
    curl -L -o index.html "https://drive.google.com/uc?export=download&id=1_SBGZE67Ullw3Xq6B9OPnIcAXBVrBsPM" &> /dev/null
    rm -rf /var/www/html/*

    systemctl status nginx > /dev/null

    NGINX_STATUS_OUTPUT=$?

    NGINX_STATUS='Dead'

if [ "$NGINX_STATUS_OUTPUT" == "$NGINX_RUNNING_STATUS" ]
    then
    NGINX_STATUS='Active'
fi

    STUDENT_NAME="Fasih Hussain"
    NGINX_VERSION=$(nginx -v 2>&1 | awk -F' ' '{print $3}' | cut -d / -f 2)
    AWS_CLI_VERSION=$(aws --version | awk '{print $1}' | tr '/' ' ' | awk '{print $2}')
    EC2_COUNT=$(aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].[InstanceId]' --output text | wc -l)
    SEC_GRP_COUNT=$(aws ec2 describe-security-groups --query "SecurityGroups[*].{Name:GroupName}"  --output text | wc -l)

    sed -i "s/STUDENTNAME/$STUDENT_NAME/g" $PWD/index.html
    sed -i "s/NGINXSTATUS/$NGINX_STATUS/g" $PWD/index.html
    sed -i "s/NGINXVERSION/$NGINX_VERSION/g" $PWD/index.html
    sed -i "s/VERSIONAWS/$AWS_CLI_VERSION/g" $PWD/index.html
    sed -i "s/EC2COUNT/$EC2_COUNT/g" $PWD/index.html
    sed -i "s/SECGRPCOUNT/$SEC_GRP_COUNT/g" $PWD/index.html

    echo 'Successfully updated index.html file to nginx'

    mv $PWD/index.html /var/www/html/

}

