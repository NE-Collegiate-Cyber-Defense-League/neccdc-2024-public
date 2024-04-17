resource "aws_iam_group" "blue_team" {
  name = "contractors"
  path = "/"
}

resource "aws_iam_group_policy_attachment" "blue_team_read" {
  group      = aws_iam_group.blue_team.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "blue_team" {
  group      = aws_iam_group.blue_team.name
  policy_arn = aws_iam_policy.blue_team_admin.id
}

resource "aws_iam_policy" "blue_team_admin" {
  name = "temporary_admin"
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "😏"
        Effect   = "Allow"
        Action   = "iam:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user" "blue_team" {
  count = var.number_of_blue_users

  name          = "contractor-${count.index + 1}"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_group_membership" "blue_team" {
  name = "blue-team-membership"

  users = [for user in aws_iam_user.blue_team : user.name]
  group = aws_iam_group.blue_team.name
}

resource "aws_iam_user_login_profile" "blue_team" {
  count                   = var.number_of_blue_users
  user                    = aws_iam_user.blue_team[count.index].name
  password_reset_required = false

  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

resource "local_file" "blue_team_creds" {
  content  = join("\n", [for user in aws_iam_user_login_profile.blue_team : "neccdl-2024-${var.team_number}, ${user.user}, ${user.password}"])
  filename = "../../../../documentation/blue_team_access/regionals/team_${var.team_number}/aws.csv"
}
