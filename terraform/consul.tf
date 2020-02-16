# Deploy Consul EC2

locals {
  consul_server_count = 1
  consul_server_ec2_type = "t2.micro"
}

# Template for initial configuration bash script
data "template_file" "consul-user_data" {
  template = "${file("./templates/user-data-consul.tpl")}"
  vars = {
    INSTANCE_HOSTNAME  = "consul.${var.loc-domain}"
  }
}

data "aws_ami" "consul-server-ami" {
  name_regex  = "^ConsulServer"
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "consul-server" {

  ami                    = data.aws_ami.consul-server-ami.id
  instance_type          = local.consul_server_ec2_type
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name
  user_data              = data.template_file.consul-user_data.rendered

  tags = {
    Name        = "Consul-Server"
    Terraform   = "True"
    Environment = var.environment 
  }
}

resource "aws_route53_record" "p-consul" {
  zone_id = aws_route53_zone.loc-domain.zone_id 
  name    = "consul.${var.loc-domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.consul-server.private_ip]
}