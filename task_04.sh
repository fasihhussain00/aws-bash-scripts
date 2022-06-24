#!/bin/bash
ROOT_UID=0
E_NOTROOT=100
ALREADY_CONFIGURED=0

if [ "$UID" -ne "$ROOT_UID" ]
   then
        echo "Must have root access to run this script. please Run it with sudo"
        exit $E_NOTROOT
fi

CURRENT_DIR="$( dirname -- "$0"; )"
source $CURRENT_DIR/task_03.sh

[[ -e ~/.aws/credentials ]]
CONFIG_STATUS=$(echo $?)
 if [ "$CONFIG_STATUS" != "$ALREADY_CONFIGURED" ]
       then
AWS_DEFAULT_REGION='us-east-1'
AWS_SECRET_ACCESS_KEY=$(aws --region=${AWS_DEFAULT_REGION} ssm get-parameter --name "access-secret-key" --with-decryption --output text --query Parameter.Value)
AWS_ACCESS_KEY_ID=$(aws --region=${AWS_DEFAULT_REGION} ssm get-parameter --name "access-key" --with-decryption --output text --query Parameter.Value)

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set default.region $AWS_DEFAULT_REGION

echo "Succesfully Configured AWS"
fi

if [ "$CONFIG_STATUS" == "$ALREADY_CONFIGURED" ]
       then
       echo "Already Configured"
fi
