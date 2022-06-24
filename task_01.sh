#!/bin/bash

ROOT_UID=0
E_NOTROOT=100
E_UNKNOWN=10

if [ "$UID" -ne "$ROOT_UID" ]
  then
   echo "Must be root to run this script. please Run it with sudo"
    exit $E_NOTROOT
fi
echo "Updating and Upgrading packages please wait..."

apt-get update > /dev/null
apt-get upgrade > /dev/null

which nginx &> /dev/null || {

                echo "Installing nginx ..."
                apt-get install nginx -y > /dev/null
                echo "Installed NGINX !"

        } && {

                echo "Updating nginx..."
                apt-get install nginx -y --upgrade > /dev/null
                echo "Succesfully Updated nginx"

        } || {

                echo "Some Error Occured while installing or updating NGINX"
                exit $E_UNKNOWN

        }

