#--------------------------------------------------------------
# ALB
#--------------------------------------------------------------
resource "aws_lb" "dashboards" {
  name               = "dashboards"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.sg_vpc_internal.this_security_group_id, module.sg_public_ingress.this_security_group_id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false # Change to true for prod

  tags = {
    Terraform = "True"
    Environment = var.environment
  }
}

#--------------------------------------------------------------
# Listeners
#--------------------------------------------------------------

resource "aws_lb_listener" "https-dashboards" {
  load_balancer_arn = aws_lb.dashboards.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl-cert-arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }
}

#--------------------------------------------------------------
# Target Groups
#--------------------------------------------------------------

# Grafana 
resource "aws_lb_target_group" "grafana-tg" {
  name     = "grafana-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
  health_check {
    matcher  = "200,302"
  }
}

#Prometheus
resource "aws_lb_target_group" "prometheus-tg" {
  name     = "prometheus-tg"
  port     = 9090
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
  health_check {
    matcher  = "200,302"
  }
}

## Jenkins
resource "aws_lb_target_group" "jenkins-tg" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
  health_check {
    matcher  = "200,302"
  }
}

## Consul
resource "aws_lb_target_group" "consul-tg" {
  name     = "consul-tg"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  
  health_check {
    matcher  = "200,301,302"
  }
}

#--------------------------------------------------------------
# Target Group Attachments 
#--------------------------------------------------------------

## GRAFANA 
resource "aws_lb_target_group_attachment" "grafana-tga" {
  target_group_arn = aws_lb_target_group.grafana-tg.arn
  target_id        = aws_instance.grafana-server.id
  port             = 3000
}

## PROMETHEUS
resource "aws_lb_target_group_attachment" "prometheus-tga" {
  target_group_arn = aws_lb_target_group.prometheus-tg.arn
  target_id        = aws_instance.prometheus-server.id
  port             = 9090
}

### JENKINS
resource "aws_lb_target_group_attachment" "jenkins-tga" {
  target_group_arn = aws_lb_target_group.jenkins-tg.arn
  target_id        = aws_instance.jenkins-server.id
  port             = 8080
}

### CONSUL
resource "aws_lb_target_group_attachment" "consul-tga" {
  target_group_arn = aws_lb_target_group.consul-tg.arn
  target_id        = aws_instance.consul-server.id
  port             = 8500
}

#--------------------------------------------------------------
# Rules
#--------------------------------------------------------------

# GRAFANA 

resource "aws_lb_listener_rule" "grafana_lbr" {
  listener_arn = aws_lb_listener.https-dashboards.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana-tg.arn
  }

  condition {
    host_header {
      values = ["grafana.${var.domain}"]
    }
  }
}

## PROMETHEUS  

resource "aws_lb_listener_rule" "prometheus_lbr" {
  listener_arn = aws_lb_listener.https-dashboards.arn
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prometheus-tg.arn
  }

  condition {
    host_header {
      values = ["prometheus.${var.domain}"]
    }
  }
}

### JENKINS  
#
resource "aws_lb_listener_rule" "jenkins_lbr" {
  listener_arn = aws_lb_listener.https-dashboards.arn
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-tg.arn
  }

  condition {
    host_header {
      values = ["jenkins.${var.domain}"]
    }
  }
}

### CONSUL  
resource "aws_lb_listener_rule" "consul_lbr" {
  listener_arn = aws_lb_listener.https-dashboards.arn
  
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul-tg.arn
  }

  condition {
    host_header {
      values = ["consul.${var.domain}"]
    }
  }
}