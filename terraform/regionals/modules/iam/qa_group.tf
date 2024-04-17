resource "aws_iam_group" "qa" {
  name = "qa"
}

resource "aws_iam_group_policy_attachment" "qa_ec2" {
  group      = aws_iam_group.qa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_user" "qa" {
  for_each = toset(var.qa_team)

  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "qa" {
  for_each = toset(var.qa_team)

  user = aws_iam_user.qa[each.value].name

  groups = [
    aws_iam_group.users.name,
    aws_iam_group.qa.name,
    aws_iam_group.employees.name
  ]
}

resource "aws_iam_access_key" "qa" {
  for_each = toset(var.qa_team)

  user = aws_iam_user.qa[each.value].name

  lifecycle {
    ignore_changes = [
      status
    ]
  }
}

resource "aws_iam_user_login_profile" "qa" {
  for_each = toset(var.qa_team)

  user = aws_iam_user.qa[each.value].name

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}
