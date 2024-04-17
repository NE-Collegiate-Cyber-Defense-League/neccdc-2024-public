resource "aws_iam_group" "admin" {
  name = "admin"
}

resource "aws_iam_group_policy_attachment" "admin_admin" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user" "admin" {
  for_each = toset(var.admins)

  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "admin" {
  for_each = toset(var.admins)

  user = aws_iam_user.admin[each.value].name

  groups = [
    aws_iam_group.admin.name,
    aws_iam_group.users.name
  ]
}

resource "aws_iam_user_login_profile" "admin" {
  for_each = toset(var.admins)

  user = aws_iam_user.admin[each.value].name

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}
