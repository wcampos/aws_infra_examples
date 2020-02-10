# Install base packages

packages=(
    vim 
    nc
    bind-utils
    iftop
    htop
    wget
)

sudo yum -y install "${packages[@]}"
sudo yum -y update
