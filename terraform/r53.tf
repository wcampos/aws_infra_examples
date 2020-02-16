data "aws_route53_zone" "domain" {
  name         = var.domain
}

resource "aws_route53_zone" "loc-domain" {
  name         = var.loc-domain

  vpc {
    vpc_id = module.vpc.vpc_id
  }

}

#Grafana
resource "aws_route53_record" "grafana" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "grafana"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.dashboards.dns_name]
}

#Prometheus
resource "aws_route53_record" "prometheus" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "prometheus"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.dashboards.dns_name]
}

#Jenkins
resource "aws_route53_record" "jenkins" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "jenkins"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.dashboards.dns_name]
}

#Consul
resource "aws_route53_record" "consul" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "consul"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.dashboards.dns_name]
}