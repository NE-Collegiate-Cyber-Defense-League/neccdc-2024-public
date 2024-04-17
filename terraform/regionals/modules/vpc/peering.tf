resource "aws_route" "blue_to_black_public" {
  provider = aws.black

  route_table_id            = data.aws_route_table.black_team_public.id
  destination_cidr_block    = "10.${var.team_number}.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "blue_to_black_private" {
  provider = aws.black

  route_table_id            = data.aws_route_table.black_team_private.id
  destination_cidr_block    = "10.${var.team_number}.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_vpc_peering_connection" "peer" {
  provider = aws.black

  vpc_id        = data.aws_vpc.black_team.id
  peer_vpc_id   = aws_vpc.team_vpc.id
  peer_owner_id = data.aws_caller_identity.blue_team.id

  tags = {
    Name = "black-to-team"
  }
}

resource "aws_vpc_peering_connection_accepter" "accepter_connection" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = {
    Name = "black-to-team"
  }
}
