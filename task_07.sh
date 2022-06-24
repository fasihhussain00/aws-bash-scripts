#!/bin/bash
ROOT_UID=0
E_NOTROOT=100


if [ "$UID" -ne "$ROOT_UID" ]
   then
        echo "Must have root access to run this script. please Run it with sudo"
        exit $E_NOTROOT
fi
source task_01.sh
source task_02.sh
source task_04.sh

AWS_DEFAULT_REGION=us-east-1
COUNT=1

declare -A instance0=(
    [region]=$AWS_DEFAULT_REGION
    [instanceType]='t2.micro'
    [keyName]='assignment-02-kp'
    [availabilityZone]='us-east-1c'
    [instanceName]='website-server'
    [ami]='ami-08d4ac5b634553e16'
    [securityGroup]='assignment-02-sg'
    [userData]='user_data.txt'
)

declare -n instance
for instance in ${!instance@}; do

    SECURITY_GROUP=$(aws ec2 describe-security-groups --filter "Name=group-name,Values=${instance[securityGroup]}" --query "SecurityGroups[*].GroupId" --output text)
    SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=availability-zone,Values=${instance[availabilityZone]}" --query "Subnets[*].SubnetId" --output text)
    TAG="ResourceType=instance,Tags=[{Key=Name,Value=${instance[instanceName]}}]"

     aws ec2 run-instances \
         --image-id ${instance[ami]} \
         --count ${COUNT} \
         --instance-type ${instance[instanceType]} \
         --key-name ${instance[keyName]} \
         --security-group-ids ${SECURITY_GROUP} \
         --subnet-id ${SUBNET_ID} \
         --tag-specifications ${TAG} \
         --user-data file://user_data.txt > /dev/null
        echo "Successfully created and uploaded website to server"
done
