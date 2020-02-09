# Install base packages

packages=(
    yum
    nc
    bind-utils
    iftop
    htop
)

sudo yum -y install "${packages[@]}"
#Add grafana OSS Repo
# https://grafana.com/docs/grafana/latest/installation/rpm/
cat <<EOF | sudo tee /etc/yum.repos.d/grafana.repo
[grafana]
name=grafana
baseurl=https://packages.grafana.com/oss/rpm
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://packages.grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF
# Install Grafana
sudo yum install -y grafana

# Reload systemctl 
sudo systemctl daemon-reload

# Start Service 
sudo systemctl start grafana-server

# Enable Service 
sudo systemctl enable grafana-server
# Install SSM Agent 
# This is not needed for AmazonLinux2 

#!/bin/bash
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
# SSM Agent Setup

# Start Service 
sudo systemctl start amazon-ssm-agent

# Enable Service 
sudo systemctl enable amazon-ssm-agent

# Install prometheus repo from gh
# https://github.com/lest/prometheus-rpm
# https://packagecloud.io/prometheus-rpm/release/install#bash-rpm
curl -s https://packagecloud.io/install/repositories/prometheus-rpm/release/script.rpm.sh | sudo bash
# Install node exporter
sudo yum install -y node_exporter

# Start Service 
sudo systemctl start node_exporter

# Enable service 
sudo systemctl enable node_exporter

