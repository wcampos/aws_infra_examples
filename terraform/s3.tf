resource "aws_s3_bucket" "s3_trf_bknd" {
  bucket = "s3-trf-bknd-dev-001"
  acl    = "private"

  tags = {
    Terraform   = "True"
    Environment = "Dev"
  }
}

