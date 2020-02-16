# Install base packages

packages=(
    vim 
    nc
    bind-utils
    iftop
    htop
    wget
    unzip
)

sudo yum -y install "${packages[@]}"
sudo yum -y update
