# List of Security Groups

## VPC INTERNAL

module "sg_vpc_internal" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_vpc_internal_traffic"
  description = "Allow ALL internal traffic in the VPC"
  vpc_id      = module.vpc.vpc_id

  # Ingress 

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "ALLOW ALL INT TRAFFIC INSIDE VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  # Egress 

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "ALLOW ALL TRAFFIC TO OUT VPC"
      cidr_blocks = "0.0.0.0/0"
    }
  ]  
}

## PUBLIC INGRESS 

data "http" "my_public_ip" {
  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  ifconfig_co_json = jsondecode(data.http.my_public_ip.body)
}

output "my_ip_addr" {
  value = local.ifconfig_co_json.ip
}

module "sg_public_ingress" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "sg_ingress_public_traffic"
  description = "Allow ingress public traffic to VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["${local.ifconfig_co_json.ip}/32"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
}
