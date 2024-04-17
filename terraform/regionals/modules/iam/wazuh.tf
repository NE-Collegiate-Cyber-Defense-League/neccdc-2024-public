resource "aws_iam_role" "wazuh" {
  name = "wazuh"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ]
}

resource "aws_iam_instance_profile" "wazuh" {
  name = "wazuh"
  role = aws_iam_role.wazuh.name
}
