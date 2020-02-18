#!/bin/bash 

# Set Version 
CONSUL_VERSION='1.6.3'
CONSUL_DOWNLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

# Download / Setup BInary 
curl -o /tmp/consul.zip ${CONSUL_DOWNLOAD_URL}
unzip /tmp/consul.zip
rm -Rf /tmp/consul.zip 
sudo mv /tmp/consul /usr/bin/

# Consul Autocomplete 
/usr/bin/consul -autocomplete-install
complete -C /usr/bin/consul consul

# Add User and Group 
sudo groupadd --system consul
sudo useradd -s /sbin/nologin --system -g consul consul

# Create Dir Structure 
sudo mkdir -p /var/lib/consul /etc/consul.d
sudo chown -R consul:consul /var/lib/consul /etc/consul.d
sudo chmod -R 775 /var/lib/consul /etc/consul.d

# Setup systemctl unit
cat <<EOF | sudo tee  /etc/systemd/system/consul.service
# Consul systemd service unit file
[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=consul
Group=consul
ExecStart=/usr/bin/consul agent -node=INSTANCE_HOSTNAME -config-dir=/etc/consul.d

ExecReload=/bin/kill -HUP
KillSignal=SIGINT
TimeoutStopSec=5
Restart=on-failure
SyslogIdentifier=consul

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF2 | sudo tee /etc/consul.d/config.json
{
     "advertise_addr": "IPADDR",
     "bind_addr": "IPADDR",
     "bootstrap_expect": 3,
     "client_addr": "0.0.0.0",
     "datacenter": "D0-AWS1",
     "data_dir": "/var/lib/consul",
     "domain": "consul",
     "enable_script_checks": true,
     "dns_config": {
         "enable_truncate": true,
         "only_passing": true
     },
     "enable_syslog": true,
     "encrypt": "XXqL0GNNC3HxSXbJs0wcr+vLftg0FKR7XaHT690CELc=",
     "leave_on_terminate": true,
     "log_level": "INFO",
     "rejoin_after_leave": true,
     "retry_join": [
         "consul-0",
         "consul-1",
         "consul-2"
     ],
     "server": true,
     "start_join": [
         "consul-0",
         "consul-1",
         "consul-2"
     ],
     "ui": true
}
EOF2

# Start and Enable Service 
sudo systemctl start consul
sudo systemctl enable consul
