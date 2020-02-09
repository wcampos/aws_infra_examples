# Deploy Grafana EC2

data "aws_ami" "grafana-server-ami" {
  name_regex  = "^GrafanaServer"
  most_recent = true
  owners      = ["self"]
}

module "grafana-server" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.12.0"

  name           = "Grafana-Server"
  instance_count = 1

  ami                    = data.aws_ami.grafana-server-ami.id
  instance_type          = "t2.micro"
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name

  tags = {
    Terraform   = "True"
    Environment = "Dev"
  }
}

