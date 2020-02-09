resource "aws_s3_bucket" "s3-alb-logs-double0" {
  bucket = "s3-alb-logs-double0"
  acl    = "private"

  tags = {
    Terraform   = "True"
    Environment = "Dev"
  }
}

