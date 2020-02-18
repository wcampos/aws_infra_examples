# Deploy Consul EC2

locals {
  consul_server_count = 3
  consul_server_ec2_type = "t2.micro"
}

# Template for initial configuration bash script
data "template_file" "consul-user_data" {
  count    = local.consul_server_count 
  template = "${file("./templates/user-data-consul.tpl")}"
  vars = {
    INSTANCE_HOSTNAME  = "consul-${count.index}" 
  }
}

data "aws_ami" "consul-server-ami" {
  name_regex  = "^ConsulServer"
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "consul-server" {
  
  count                  = local.consul_server_count  
  ami                    = data.aws_ami.consul-server-ami.id
  instance_type          = local.consul_server_ec2_type
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[element(range(length(module.vpc.public_subnets)), count.index)]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name
  user_data              = element(data.template_file.consul-user_data.*.rendered, count.index)

  tags = {
    Name        = "Consul-Server-${count.index}"
    Terraform   = "True"
    Environment = var.environment 
  }
}

resource "aws_route53_record" "p-consul" {
  count   = local.consul_server_count
  zone_id = aws_route53_zone.loc-domain.zone_id 
  name    = "consul-${count.index}.${var.loc-domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.consul-server.*.private_ip[count.index]]
}