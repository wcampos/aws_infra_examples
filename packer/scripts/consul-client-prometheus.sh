# Consul Setup for Prometheus 

cat <<EOF | sudo tee /etc/consul.d/client/prometheus.json

{
  "service": {
    "name": "prometheus",
    "tags": [
      "metrics"
    ],
    "port": 9090,
     "checks": [
      {
          "interval" :"10s",
          "timeout" : "2s",
          "id": "prometheus",
          "name": "HTTP prometheus 9090",
          "http": "http://localhost:9090/targets",
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

cat <<EOF3 | sudo tee -a /etc/prometheus/prometheus.yml
scrape_configs:
  - job_name: 'consul'
    consul_sd_configs:
      - server: 'localhost:8500'
    relabel_configs:
      - source_labels: [__meta_consul_tags]
        regex: .*,metrics,.*
        action: keep
      - source_labels: [__meta_consul_service]
        target_label: job
EOF3

sudo systemctl restart prometheus
