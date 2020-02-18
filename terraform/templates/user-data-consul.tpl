#!/bin/bash

exec 1> user_data.out
2>&1
id
sudo hostnamectl --static set-hostame "${INSTANCE_HOSTNAME}" 
sudo echo "${INSTANCE_HOSTNAME}" > /etc/hostname
sudo systemctl restart systemd-hostnamed
sudo echo 'preserve_hostname: true' >> /etc/cloud/cloud.cfg 
sudo sed -i "s/INSTANCE_HOSTNAME/${INSTANCE_HOSTNAME}/g" etc/systemd/system/consul.service
sudo sed -i "s/IPADDR/$(curl http://169.254.169.254/latest/meta-data/local-ipv4)/g" /etc/consul.d/config.json
systemctl daemon-reload
sudo echo "script completed" > /root/status.txt
sudo echo "$(curl http://169.254.169.254/latest/meta-data/local-ipv4)" >> /root/status.txt 
sudo reboot
