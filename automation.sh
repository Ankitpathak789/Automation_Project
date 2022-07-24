#!/bin/bash

name="ankit"
s3_bucket="upgrad-ankit1997"

apt update -y

if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]] ;
then
	apt install apache2 -y
fi

Status_Running=$(systemctl status apache2 | awk '{print $3}' | tr -d '()')

if [[ running != ${Status_Running} ]];
then
	systemctl start apache2
fi

Status_Enabled=$(systemctl is-enabled apache2 | grep "enabled")

if [[ enabled != ${Status_Enabled} ]];
then
	systemctl enable apache2
fi

timestamp=$(date '+%d%m%Y-%H%M%S')

cd /var/log/apache2

tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

if [[ -f /tmp/${name}-httpd-logs-${timestamp}.tar ]];
then
	aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi
