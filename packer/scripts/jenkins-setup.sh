# Jenkins setup script

PACKAGES=(
    java
    jenkins
)

# Install 
sudo yum install -y ${PACKAGES[@]}

# Start Service
sudo systemctl start jenkins

# Enable Service
sudo systemctl enable jenkins