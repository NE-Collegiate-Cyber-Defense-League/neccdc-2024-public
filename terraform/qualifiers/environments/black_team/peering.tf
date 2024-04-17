resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id = module.vpc.vpc_id
  vpc_id      = aws_vpc.team_vpc.id
  auto_accept = true

  tags = {
    Name = "black-to-team-vpc-peering"
    team = "shared"
  }
}

resource "aws_route" "public_black_route_to_team_vpc" {
  route_table_id            = module.vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "public_black_route_to_team_secondary_cidr" {
  route_table_id            = module.vpc.public_route_table_ids[0]
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "private_black_route_to_team_vpc" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "private_black_route_to_team_secondary_cidr" {
  route_table_id            = module.vpc.private_route_table_ids[0]
  destination_cidr_block    = "10.1.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
