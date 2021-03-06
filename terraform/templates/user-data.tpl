#!/bin/bash

exec 1> user_data.out
2>&1
id
sudo hostnamectl --static set-hostame "${INSTANCE_HOSTNAME}" 
sudo echo "${INSTANCE_HOSTNAME}" > /etc/hostname
sudo systemctl restart systemd-hostnamed
sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg 
#Consul-Client
sudo sed -i "s/HOSTNAME/$(${INSTANCE_HOSTNAME} | cut -f1 -d'.')/g" /etc/systemd/system/consul.service   
sudo sed -i "s/HOSTNAME/$(${INSTANCE_HOSTNAME} | cut -f1 -d'.')/g" /etc/consul.d/client/config.json
reboot