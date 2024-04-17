resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.team_vpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.${var.team_number}.169.0/24"

  tags = merge(var.default_tags, {
    Name    = "private"
    network = "private"
  })
}

resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.team_vpc.id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.${var.team_number}.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 999
    action     = "allow"
    cidr_block = "172.16.0.0/12"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 1000
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.default_tags, {
    Name = "private"
  })
}

resource "aws_network_acl_association" "private" {
  subnet_id      = aws_subnet.private.id
  network_acl_id = aws_network_acl.private.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.team_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.team.id
  }

  route {
    cidr_block                = "172.16.0.0/12"
    vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter_connection.id
  }

  tags = {
    Name    = "private-corp"
    network = "private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
