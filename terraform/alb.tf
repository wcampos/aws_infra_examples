module "dashboards" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  
  name = "dashboards"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [module.sg_vpc_internal.this_security_group_id, module.sg_public_ingress.this_security_group_id]
  
#  access_logs = {
#    bucket = "s3-alb-logs-double0"
#  }

  target_groups = [
    {
      name_prefix      = "grfn"
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "instance"
    },
    {
      name_prefix      = "prmths"
      backend_protocol = "HTTP"
      backend_port     = 9090
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.ssl-cert-arn 
      target_group_index = 0
    }
  ]

  tags = {
    Terraform = "True"
    Environment = var.environment
  }
}

################################################################
# ALB TargetGroup Attachments                                 # 
################################################################

## GRAFANA 
resource "aws_lb_target_group_attachment" "grafana" {
  target_group_arn = module.dashboards.target_group_arns[0]
  target_id        = module.grafana-server[0].id
  port             = 3000
}

## PROMETHEUS
resource "aws_lb_target_group_attachment" "prometheus" {
  target_group_arn = module.dashboards.target_group_arns[1]
  target_id        = module.prometheus-server[0].id 
  port             = 9090
}

################################################################
# ALB Rules                                                   # 
################################################################

## GRAFANA 
#
#resource "aws_lb_listener_rule" "grafana" {
#  listener_arn = module.dashboards.https_listener_arns[0]
#
#  action {
#    type             = "forward"
#    target_group_arn = module.dashboards.target_group_arns[0]
#  }
#
#  condition {
#    host_header {
#      values = [aws_route53_record.grafana.name]
#    }
#  }
#}
#
### PROMETHEUS  
#
#resource "aws_lb_listener_rule" "prometheus" {
#  listener_arn = module.dashboards.https_listener_arns[0]
#
#  action {
#    type             = "forward"
#    target_group_arn = module.dashboards.target_group_arns[1]
#  }
#
#  condition {
#    host_header {
#      values = [aws_route53_record.prometheus.name]
#    }
#  }
#}


