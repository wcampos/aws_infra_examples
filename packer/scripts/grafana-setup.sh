# Install Grafana
sudo yum install -y grafana

# Reload systemctl 
sudo systemctl daemon-reload

# Start Service 
sudo systemctl start grafana-server

# Enable Service 
sudo systemctl enable grafana-server
