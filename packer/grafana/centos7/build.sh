# Grafana builder 

SCRIPTS=(
    base-setup.sh
    grafana-repo.sh
    grafana-setup.sh
    ssm-install.sh
    ssm-setup.sh
    centos7-prometheus-repo.sh
    centos7-node_exporter-setup.sh
    consul-client-setup.sh
    consul-client-grafana.sh
)

for SCR in "${SCRIPTS[@]}"; do 
    cat ../../scripts/$SCR >> grafana-build-bootstrap.sh
done

packer build build-ami.json

rm -f grafana-build-bootstrap.sh
