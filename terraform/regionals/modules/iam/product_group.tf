resource "aws_iam_group" "product" {
  name = "product"
}

resource "aws_iam_group_policy_attachment" "product_marketplace" {
  group      = aws_iam_group.product.name
  policy_arn = "arn:aws:iam::aws:policy/AWSMarketplaceSellerProductsFullAccess"
}

resource "aws_iam_group_policy_attachment" "product_s3" {
  group      = aws_iam_group.product.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_user" "product" {
  for_each = toset(var.product_team)

  name          = each.value
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_group_membership" "product" {
  for_each = toset(var.product_team)

  user = aws_iam_user.product[each.value].name

  groups = [
    aws_iam_group.product.name,
    aws_iam_group.employees.name,
    aws_iam_group.users.name
  ]
}

resource "aws_iam_user_login_profile" "product" {
  for_each = toset(var.product_team)

  user = aws_iam_user.product[each.value].name

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key
    ]
  }
}
