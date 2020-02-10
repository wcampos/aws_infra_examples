# Grafana builder 

SCRIPTS=(
    base-setup.sh
    ssm-install.sh
    ssm-setup.sh
    centos7-prometheus-repo.sh 
    centos7-node_exporter-setup.sh
    jenkins-repo.sh
    jenkins-setup.sh
)

for SCR in "${SCRIPTS[@]}"; do 
    cat ../scripts/$SCR >> jenkins-build-bootstrap.sh
done

packer build build-ami.json

rm -f jenkins-build-bootstrap.sh
