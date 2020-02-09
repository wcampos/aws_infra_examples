resource "aws_iam_instance_profile" "default_instance_role" {
  name = "default_instance_role"
  role = aws_iam_role.default_role.name
}

resource "aws_iam_role" "default_role" {
    name = "default_role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
    tags = {
      Terraform = "True"
      Environment = "Dev"
    }
}

resource "aws_iam_policy_attachment" "ssm-policy-attach" {
  name       = "ssm-policy-attach"
  roles      = [aws_iam_role.default_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
