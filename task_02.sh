#!/bin/bash
ROOT_UID=0
E_NOTROOT=100
NGINX_RUNNING_STATUS=0
NGINX_NOT_RUNNING_STATUS=3
SYSTEMCTL_START_SUCCESS=0

RED="\e[1;31m"
GREEN="\e[1;32m"
CE="\e[m"

if [ "$UID" -ne "$ROOT_UID" ]
   then
        echo "Must have root access to run this script. please Run it with sudo"
        exit $E_NOTROOT
fi

systemctl status nginx > /dev/null
NGINX_STATUS_OUTPUT=$?

if [ "$NGINX_STATUS_OUTPUT" == "$NGINX_RUNNING_STATUS" ]
        then
                echo -e "$GREEN""NGINX is Running$CE"
fi

if [ "$NGINX_STATUS_OUTPUT" == "$NGINX_NOT_RUNNING_STATUS" ]
        then
                echo -e "$RED""NGINX is Dead. Do you want to run NGINX [y/n]?$CE"
                read -rp ''  NGINX_SHOULD_START

                if [[ $NGINX_SHOULD_START =~ ^([yY])$ ]]
                        then
                                echo "Starting NGINX..."

                                        systemctl enable nginx
                                        systemctl start nginx

                                if [[ "$?" != "$SYSTEMCTL_START_SUCCESS" ]]
                                        then
                                        echo -e "$RED""Something went wrong, NGINX cannot be activated"
                                        exit 2
                                fi

                                echo "Succesfully stated NGINX"
                fi
fi
