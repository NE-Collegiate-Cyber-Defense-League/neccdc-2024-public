resource "aws_key_pair" "blue_team_key" {
  key_name   = "blue-team"
  public_key = file(var.blue_team_access_key)
}

resource "aws_key_pair" "black_team" {
  key_name   = "black-team"
  public_key = file(var.black_team_key)
}
