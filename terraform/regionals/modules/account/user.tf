resource "aws_iam_user" "black_team" {
  name = "black-team"
  path = "/ORG/"

  tags = var.default_tags
}

resource "aws_iam_access_key" "black_team_key" {
  user = aws_iam_user.black_team.name
}

resource "aws_iam_user_policy_attachment" "black_team_admin" {
  user       = aws_iam_user.black_team.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_login_profile" "black_team" {
  user                    = aws_iam_user.black_team.name
  password_reset_required = false

  # Reversed enginered with pgp.
  # Followed a comment on this https://www.reddit.com/r/Terraform/comments/t9jcms/aws_iam_user_with_password_access_and_secret_keys/

  # Password:
  # PASSWORD
  pgp_key = "xsBNBGXGdkwBCADyE/BmgEzOg/7LjyhtTB0AggCoi4f2j/6rBOoLufSMk56PLD/Vzj74lvYXSg9kHqtGsuSgfYskXuuKg8Lhv4S94P2a4w8NlyvH1ufHJkDtrzNkSR+Zic3pFbFuN5gUoiuhpjCLi5NvEiYRDgbUDju23HNgurUMG7DOJW4P9CIbpQxuZzG884VyDzR/vIvxKFe/nW5PiVv/VvbRsMjjR2HQpnDSFWd8xoDqtfLuevofIAQ8L8KWZntjS1W3mhzC5GvWtcs4aC45zj5+c+0Y5h0jaJxLqQpBjw8gywqv0iKaxIsfEeDXlKRX34BrnHHon4dzc2hRsWbhJ6KgfxTpd1qNABEBAAHNO2JsYWNrLXRlYW0gKFBHUCBLZXkgZm9yIGJsYWNrLXRlYW0pIDxibGFjay10ZWFtQG5lY2NkbC5vcmc+wsBiBBMBCAAWBQJlxnZMCRBP39Rw1HurggIbAwIZAQAAOEAIAEiGbEhEaaikAzg4l9JY+Nimm6PFN902w/0tYg/JjvV+bax6FaQpAcxjQ7c+CCz1KrhFAkJnEIV0zDhJDKXbJiAG4whdd5swDxta2zvnEYRSiBZtMss36dqmpO+kcvNHjeY4K4+7cbBHLgnMEZRNGRUANwmjJxXNE9khaKvBut4XaEVcQkuuTOtsP40mKTUk8fWkwB3EOaxe/Lfnkun4DlsMRB9rt9GX/b5udNdq1i9dYbXYRTc7xmAUbzMgYntJtE+SawEgJI2Eu1/j+V/O1jLdyvo4US+FBvmVISu116dDMtMxyatOQGoXikgu0HMUN4e47HsoEJ0dn9VN0UBOXZnOwE0EZcZ2TAEIANSi0gCluyaaWMg4FZw+BNM8KerSCTGbwTTAa8RXe6nU/T5T9ilPjLEj3JGAwCawSHuftK4RHdOJzGakiDNJABb5+nvNHLn1NWLmlpyssI+EDxXnPh4p6zow6D+E1a/9yAPVJf2KWfJ7Pb6vlp92HR2JTwcXEJHAycfEQT6tQ1rROgGUOYGkIhNLv1bQeeyQFOogvec3EjTGHT+HleSdbg/xg0/Qn2JeF57CldTkvdfn3+T5ZQPGig2bbW8Qu6KJMkvbG2Y1yfHqvftyFHVViP5DiRK7YPQ75SbTqGcBNLClb2o7ZeC0ihrGmjIi1D5wQ2CGSbHyUJ4q5iLFz2KUsEEAEQEAAcLAXwQYAQgAEwUCZcZ2TAkQT9/UcNR7q4ICGwwAAAG4CABzRxCrihkND0dYddaGtg5iYPUI9oE1CmiTQg88Joz6ZAssMFO+glMMIhNHf7nTRQo4V0q3vonHoqzENOUcFwLSnrFG1OGyyXhY7PCCoqBdQWHjJrIaJerA9PsGkz1stfPjxqLOBUsSU30xDy5NY0CUGw0onQVajpJYkyzp/fUMP4QRos0/nHGRMJl9HuvV6LeFXc3Fa/9Z4IPRBFUgg1TsxP/QztFNUXPjQSd2+i8EnxL0c+4rBG9CODl8e8ldcy/N+PNOoLkRocmlCiYkAD5Oj5gPrSoBNSFUZY2I8P+GQSZkJLoflep90maM/h8SZ4RPHt0a6qPmXM8r5aw6Lmxw"
}
