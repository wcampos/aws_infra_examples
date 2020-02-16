#!/bin/bash

exec 1> user_data.out
2>&1
id
sudo hostnamectl --static set-hostame "${INSTANCE_HOSTNAME}" 
sudo echo "${INSTANCE_HOSTNAME}" > /etc/hostname
sudo systemctl restart systemd-hostnamed
sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg 
sudo sed -i "s/IPADDR/$(dig +short ${INSTANCE_HOSTNAME})/g" /etc/consul.d/config.json
systemctl daemon-reload
sudo echo "script completed" > /root/status.txt
sudo echo "$(dig +short ${INSTANCE_HOSTNAME})" >> /root/status.txt 
sudo reboot
