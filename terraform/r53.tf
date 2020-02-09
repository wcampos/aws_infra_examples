data "aws_route53_zone" "domain" {
  name         = var.domain
}

#Grafana
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "grafana"
  type    = "CNAME"
  ttl     = "300"
  records = [module.dashboards.this_lb_dns_name]
}

#Prometheus
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "300"
  records = [module.dashboards.this_lb_dns_name]
}
