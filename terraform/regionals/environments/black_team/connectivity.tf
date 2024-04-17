resource "aws_key_pair" "black_team" {
  key_name   = "black-team"
  public_key = file("../../../../documentation/black_team/black-team.pub")
}

resource "aws_iam_role" "only_ssm" {
  name        = "OnlySSM"
  description = "Allow black team ssm permissiosn"
  path        = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "only_ssm" {
  name = "only_ssm"
  role = aws_iam_role.only_ssm.name
}
