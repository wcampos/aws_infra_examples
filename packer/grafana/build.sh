# Grafana builder 

SCRIPTS=(
    base-setup.sh
    grafana-repo.sh
    grafana-setup.sh
    ssm-setup.sh
)

for SCR in "${SCRIPTS[@]}"; do 
    cat ../scripts/$SCR >> grafana-build-bootstrap.sh
done

packer build build-ami.json

rm -f grafana-build-bootstrap.sh
