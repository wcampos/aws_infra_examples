# Install node exporter
sudo yum install -y node_exporter

# Start Service 
sudo systemctl start node_exporter

# Enable service 
sudo systemctl enable node_exporter

