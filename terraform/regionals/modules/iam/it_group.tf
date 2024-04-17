resource "aws_iam_group" "it" {
  name = "it"
}

resource "aws_iam_group_policy_attachment" "it_ec2" {
  group      = aws_iam_group.it.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "it_vpc" {
  group      = aws_iam_group.it.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_group_policy_attachment" "it_s3" {
  group      = aws_iam_group.it.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "it" {
  for_each = toset(var.it_team)

  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "it" {
  for_each = toset(var.it_team)

  user = aws_iam_user.it[each.value].name

  groups = [
    aws_iam_group.it.name,
    aws_iam_group.employees.name,
    aws_iam_group.users.name
  ]
}

resource "aws_iam_access_key" "it" {
  for_each = toset(var.it_team)

  user = aws_iam_user.it[each.value].name

  lifecycle {
    ignore_changes = [
      status
    ]
  }
}

resource "aws_iam_user_login_profile" "it" {
  for_each = toset(var.it_team)

  user = aws_iam_user.it[each.value].name

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}
