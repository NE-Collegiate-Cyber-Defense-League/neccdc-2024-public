resource "aws_iam_group" "users" {
  name = "users"
}

resource "aws_iam_group_policy_attachment" "users" {
  group      = aws_iam_group.users.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy" "user_inline" {
  name  = "update-keys"
  group = aws_iam_group.users.name

  policy = <<-POLICY
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "VisualEditor0",
          "Effect": "Allow",
          "Action": [
            "iam:GetAccountPasswordPolicy",
            "iam:GetAccountSummary"
          ],
          "Resource": "*"
        },
        {
          "Sid": "VisualEditor2",
          "Effect": "Allow",
          "Action": [
            "iam:GetUser",
            "iam:DeleteAccessKey",
            "iam:UpdateAccessKey",
            "iam:CreateAccessKey",
            "iam:ListAccessKeys",
            "iam:GetAccessKeyLastUsed",
            "iam:DeactivateMFADevice",
            "iam:EnableMFADevice",
            "iam:GetUser",
            "iam:ListMFADevices",
            "iam:ResyncMFADevice"
          ],
          "Resource": "arn:aws:iam::*:user/*$${aws:username}"
        },
        {
          "Sid": "AllowManageOwnVirtualMFADevice",
          "Effect": "Allow",
          "Action": [
            "iam:ListVirtualMFADevices",
            "iam:CreateVirtualMFADevice",
            "iam:DeleteVirtualMFADevice"
          ],
          "Resource": "arn:aws:iam::*:mfa/$${aws:username}"
        }
      ]
    }
  POLICY
}
