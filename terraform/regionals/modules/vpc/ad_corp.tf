resource "aws_subnet" "ad_corp" {
  vpc_id                  = aws_vpc.team_vpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.${var.team_number}.0.0/17"

  tags = merge(var.default_tags, {
    Name    = "ad-corp"
    network = "public"
  })
}

resource "aws_network_acl" "ad_corp" {
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
    Name = "ad_corp"
  })
}

resource "aws_network_acl_association" "ad_corp" {
  subnet_id      = aws_subnet.ad_corp.id
  network_acl_id = aws_network_acl.ad_corp.id
}

resource "aws_route_table" "ad_corp" {
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
    Name    = "ad-corp"
    network = "private"
  }
}

resource "aws_route_table_association" "ad_corp" {
  subnet_id      = aws_subnet.ad_corp.id
  route_table_id = aws_route_table.ad_corp.id
}
