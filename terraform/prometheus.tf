# Deploy Prometheus EC2

locals {
  prometheus_server_count = 1
  prometheus_server_ec2_type = "t2.micro"
}

data "template_file" "prometheus-user_data" {
  template = "${file("./templates/user-data.tpl")}"
  vars = {
    INSTANCE_HOSTNAME="prometheus.${var.loc-domain}"
  }
}

data "aws_ami" "prometheus-server-ami" {
  name_regex  = "^PrometheusServer"
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance"  "prometheus-server" {

  ami                    = data.aws_ami.prometheus-server-ami.id
  instance_type          = local.prometheus_server_ec2_type
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name
  user_data              = data.template_file.prometheus-user_data.rendered

  tags = {
    Name        = "Prometheus-Server"
    Terraform   = "True"
    Environment = var.environment 
  }
}

resource "aws_route53_record" "p-prometheus" {
  zone_id = aws_route53_zone.loc-domain.zone_id
  name    = "prometheus.${var.loc-domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.prometheus-server.private_ip]
}
