# Consul Setup for Jenkins

cat <<EOF | sudo tee /etc/consul.d/client/jenkins.json

{
  "service": {
    "name": "jenkins",
    "tags": [
      "metrics"
    ],
    "port": 8080,
     "checks": [
      {
          "interval" :"10s",
          "timeout" : "2s",
          "id": "jenkins",
          "name": "HTTP jenkins 8080",
          "http": "http://localhost:8080/",
          "tls_skip_verify": false
      }
    ]
  }
}
EOF

cat <<EOF2 | sudo tee /etc/consul.d/client/node_exporter.json 
{
  "service": {
    "name": "node-exporter",
    "tags": [
      "metrics"
    ],
    "port": 9100,
     "checks": [
      {
          "interval" :"10s",
          "timeout" : "2s",
          "id": "prometheus",
          "name": "Node Exporter HTTP 9100",
          "http": "http://localhost:9100/metric"
      }
    ]
  }
}
EOF2
