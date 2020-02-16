# Grafana builder 

SCRIPTS=(
    base-setup.sh
    ssm-install.sh
    ssm-setup.sh
    centos7-prometheus-repo.sh 
    centos7-node_exporter-setup.sh
    consul-setup.sh
)

for SCR in "${SCRIPTS[@]}"; do 
    cat ../scripts/$SCR >> consul-build-bootstrap.sh
done

packer build build-ami.json

rm -f consul-build-bootstrap.sh
