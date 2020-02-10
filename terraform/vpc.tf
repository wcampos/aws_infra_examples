module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = "vpc-dev"
  cidr = var.vpc_cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  # DHCP OPTIONS
  enable_dhcp_options              = true
  dhcp_options_domain_name         = "${var.loc-domain}"
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  # Hostname Resolution
  enable_dns_hostnames             = true

  # VPC endpoint for S3
  enable_s3_endpoint = true

  tags = {
    Terraform   = "True"
    Environment = "Dev"
  }
}

