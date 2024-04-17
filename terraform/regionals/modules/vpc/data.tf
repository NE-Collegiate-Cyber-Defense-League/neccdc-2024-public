data "aws_caller_identity" "blue_team" {}

data "aws_vpc" "black_team" {
  provider = aws.black

  filter {
    name   = "tag:Name"
    values = ["black-team"]
  }

  filter {
    name   = "tag:competition"
    values = ["regionals"]
  }
}

data "aws_route_table" "black_team_public" {
  provider = aws.black

  vpc_id = data.aws_vpc.black_team.id
  filter {
    name   = "tag:Name"
    values = ["black-team-public"]
  }
}

data "aws_route_table" "black_team_private" {
  provider = aws.black

  vpc_id = data.aws_vpc.black_team.id
  filter {
    name   = "tag:Name"
    values = ["black-team-private"]
  }
}
