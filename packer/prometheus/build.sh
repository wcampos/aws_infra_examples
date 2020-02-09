# Grafana builder 

SCRIPTS=(
    base-setup.sh
    ssm-install.sh
    ssm-setup.sh
    centos7-prometheus-repo.sh 
    centos7-prometheus-setup.sh
    centos7-node_exporter-setup.sh
)

for SCR in "${SCRIPTS[@]}"; do 
    cat ../scripts/$SCR >> prometheus-build-bootstrap.sh
done

packer build build-ami.json

rm -f prometheus-build-bootstrap.sh
