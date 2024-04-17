resource "aws_iam_role" "vault" {
  name = "vault"
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
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}

resource "aws_iam_instance_profile" "vault" {
  name = "vault"
  role = aws_iam_role.vault.name
}
