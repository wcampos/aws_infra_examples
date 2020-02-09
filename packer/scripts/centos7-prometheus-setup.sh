# Setup prometheus server

Services=(
  prometheus
  alertmanager
  pushgateway
)

# Install services
sudo yum install -y ${Services[@]}

# Start Services
sudo systemctl start ${Services[@]}

# Enable Services
sudo systemctl enable ${Services[@]}
