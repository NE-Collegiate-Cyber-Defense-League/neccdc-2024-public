resource "aws_iam_group" "employees" {
  name = "employees"
}

resource "aws_iam_group_policy_attachment" "employees" {
  group      = aws_iam_group.employees.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}
