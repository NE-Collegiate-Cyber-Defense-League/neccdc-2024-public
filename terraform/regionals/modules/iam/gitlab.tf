resource "aws_iam_role" "gitlab" {
  name = "gitlab"
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
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    aws_iam_policy.gitlab_policy.arn
  ]
}

resource "aws_iam_policy" "gitlab_policy" {
  name = "gitlab-cicd"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:Get*",
          "ec2:Describe*",
          "ec2:RunInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "gitlab" {
  name = "gitlab"
  role = aws_iam_role.gitlab.name
}
