data "aws_vpc" "black_team" {
  filter {
    name   = "tag:Name"
    values = ["black-team"]
  }
}

data "aws_vpc" "team_team" {
  filter {
    name   = "tag:Name"
    values = ["Mega-team-vpc"]
  }
}

data "aws_route_table" "team_networked" {
  vpc_id = data.aws_vpc.team_team.id

  filter {
    name   = "tag:team"
    values = ["shared"]
  }

  filter {
    name   = "tag:network"
    values = ["private-public"]
  }
}

data "aws_route_table" "team_private" {
  vpc_id = data.aws_vpc.team_team.id

  filter {
    name   = "tag:team"
    values = ["shared"]
  }

  filter {
    name   = "tag:network"
    values = ["private"]
  }
}

data "aws_security_group" "team" {
  vpc_id = data.aws_vpc.team_team.id

  filter {
    name   = "tag:Name"
    values = ["blue-team-sg"]
  }

  filter {
    name   = "tag:team"
    values = ["shared"]
  }
}

data "aws_key_pair" "black_team" {
  key_name           = "black-team"
  include_public_key = true
}

