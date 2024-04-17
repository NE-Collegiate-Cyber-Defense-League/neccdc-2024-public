resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.team_vpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.${var.team_number}.255.208/28"

  tags = merge(var.default_tags, {
    Name    = "public"
    network = "public"
  })
}


resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.team_vpc.id

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
    Name = "public"
  })
}

resource "aws_network_acl_association" "public" {
  subnet_id      = aws_subnet.public.id
  network_acl_id = aws_network_acl.public.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.team_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team.id
  }

  route {
    cidr_block                = "172.16.0.0/12"
    vpc_peering_connection_id = aws_vpc_peering_connection_accepter.accepter_connection.id
  }

  tags = {
    Name    = "public-corp"
    network = "private"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
