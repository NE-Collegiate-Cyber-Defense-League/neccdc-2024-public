resource "aws_iam_account_alias" "account_alias" {
  account_alias = "neccdl-2024-${var.team_number}"
}

resource "aws_iam_account_password_policy" "strict" {
  max_password_age = 1
  password_reuse_prevention = 10

  minimum_password_length        = 6
  require_lowercase_characters   = false
  require_numbers                = false
  require_uppercase_characters   = false
  require_symbols                = false
  allow_users_to_change_password = true
}
