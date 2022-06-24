#!/bin/bash

ROOT_UID=0
E_NOTROOT=100
ARCH=$(uname -i)


if [ "$UID" -ne "$ROOT_UID" ]
   then
        echo "Must have root access to run this script. please Run it with sudo"
        exit $E_NOTROOT
fi


which aws &> /dev/null && {
    AWS_VERSION=$(aws --version | awk '{print $1}' | tr '/' ' ')
                echo "$AWS_VERSION is already installed in your machine"
}

which aws &> /dev/null || {
    which curl &> /dev/null || apt install curl -y && echo "curl is installed"
    which unzip &> /dev/null || apt install unzip -y && echo "unzip is installed"

    curl -s "https://awscli.amazonaws.com/awscli-exe-linux-$ARCH.zip" -o "awscliv2.zip"

    unzip "$PWD/awscliv2.zip" > /dev/null
    sudo "$PWD/aws/install" > /dev/null
    rm "$PWD/awscliv2.zip" > /dev/null
   echo "AWS CLI is installed succesfully"
}
