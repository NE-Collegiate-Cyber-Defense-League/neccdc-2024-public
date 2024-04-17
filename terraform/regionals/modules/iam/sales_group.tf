resource "aws_iam_group" "sales" {
  name = "sales"
}

resource "aws_iam_group_policy_attachment" "sales_sales" {
  group      = aws_iam_group.sales.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "sales" {
  for_each = toset(var.sales_team)

  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "sales" {
  for_each = toset(var.sales_team)

  user = aws_iam_user.sales[each.value].name

  groups = [
    aws_iam_group.users.name,
    aws_iam_group.sales.name,
    aws_iam_group.employees.name
  ]
}

resource "aws_iam_user_login_profile" "sales" {
  for_each = toset(var.sales_team)

  user = aws_iam_user.sales[each.value].name

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}
