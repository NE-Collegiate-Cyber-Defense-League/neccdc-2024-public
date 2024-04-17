resource "aws_iam_group" "security" {
  name = "security"
}

resource "aws_iam_group_policy_attachment" "security_ec2" {
  group      = aws_iam_group.security.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "security_audit" {
  group      = aws_iam_group.security.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCloudTrail_FullAccess"
}

resource "aws_iam_group_policy_attachment" "security_s3_full" {
  group      = aws_iam_group.security.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy" "security_inline" {
  name  = "AccessControlController"
  group = aws_iam_group.security.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "iam:DeleteAccessKey",
          "iam:GetAccessKeyLastUsed",
          "iam:UpdateAccessKey",
          "iam:CreateAccessKey",
          "iam:ListAccessKeys",
          "iam:CreateLoginProfile"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
