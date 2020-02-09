# Install base packages

packages=(
    yum
    nc
    bind-utils
    iftop
    htop
)

sudo yum -y install "${packages[@]}"
