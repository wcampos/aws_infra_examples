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

sudo cat <<SERVER >> /etc/prometheus/prometheus.yml
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'consul'
    consul_sd_configs:
      - server: 'localhost:8500'
    relabel_configs:
      - source_labels: [__meta_consul_tags]
        regex: .*,metrics,.*
        action: keep
      - source_labels: [__meta_consul_service]
        target_label: job
SERVER

sudo systemctl restart prometheus
