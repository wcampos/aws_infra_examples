# Deploy Jenkins EC2

locals {
  jenkins_server_count = 1
  jenkins_server_ec2_type = "t2.micro"
}

# Template for initial configuration bash script
data "template_file" "jenkins-user_data" {
  template = "${file("./templates/user-data.tpl")}"
  vars = {
    INSTANCE_HOSTNAME = "jenkins.${var.loc-domain}"
  }
}


data "aws_ami" "jenkins-server-ami" {
  name_regex  = "^JenkinsServer"
  most_recent = true
  owners      = ["self"]
}

resource "aws_instance" "jenkins-server" {

  ami                    = data.aws_ami.jenkins-server-ami.id
  instance_type          = local.jenkins_server_ec2_type
  key_name               = "nerve"
  monitoring             = true
  vpc_security_group_ids = [module.sg_vpc_internal.this_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_instance_role.name
  user_data              = data.template_file.jenkins-user_data.rendered

  tags = {
    Name        = "Jenkins-Server"
    Terraform   = "True"
    Environment = var.environment 
  }
}

resource "aws_route53_record" "p-jenkins" {
  zone_id = aws_route53_zone.loc-domain.zone_id 
  name    = "jenkins.${var.loc-domain}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.jenkins-server.private_ip]
}