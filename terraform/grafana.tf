# Deploy Grafana EC2

locals {
  grafana_server_count = 1
  grafana_server_ec2_type = "t2.micro"
}

# Template for initial configuration bash script
data "template_file" "grafana-user_data" {
  template = "${file("./templates/user-data.tpl")}"
  vars = {
    INSTANCE_HOSTNAME = "grafana.${var.loc-domain}"
  }
}


data "aws_ami" "grafana-server-ami" {
  name_regex  = "^GrafanaServer"
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "grafana-server" {

  ami                    = data.aws_ami.grafana-server-ami.id
  instance_type          = local.grafana_server_ec2_type
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name
  user_data              = data.template_file.grafana-user_data.rendered

  tags = {
    Name        = "Grafana-Server"
    Terraform   = "True"
    Environment = var.environment 
  }
}

resource "aws_route53_record" "p-grafana" {
  zone_id = aws_route53_zone.loc-domain.zone_id 
  name    = "grafana.${var.loc-domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.grafana-server.private_ip]
}

