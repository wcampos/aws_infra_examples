# Consul Setup for Grafana

cat <<EOF | sudo tee /etc/consul.d/client/grafana.json

{
  "service": {
    "name": "grafana",
    "tags": [
      "metrics"
    ],
    "port": 3000,
     "checks": [
      {
          "interval" :"10s",
          "timeout" : "2s",
          "id": "grafana",
          "name": "HTTP grafana 3000 ",
          "http": "http://localhost:3000/",
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
