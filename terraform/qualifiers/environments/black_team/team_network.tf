resource "aws_vpc" "team_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Mega-team-vpc"
    team = "shared"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.team_vpc.id
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "team_public" {
  depends_on = [
    aws_vpc_ipv4_cidr_block_association.secondary_cidr
  ]

  vpc_id                  = aws_vpc.team_vpc.id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.1.1.0/24"

  tags = {
    Name = "team-public-subnet"
    team = "shared"
  }
}

resource "aws_internet_gateway" "team" {
  vpc_id = aws_vpc.team_vpc.id

  tags = {
    Name = "team-internet-gateway"
    team = "shared"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "team-nat-gateway-eip"
    team = "shared"
  }
}

resource "aws_nat_gateway" "team" {
  depends_on = [
    aws_internet_gateway.team
  ]

  subnet_id     = aws_subnet.team_public.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "team-nat-gateway"
    team = "shared"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.team_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.team.id
  }

  route {
    cidr_block                = "172.16.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name    = "team-public-route-table"
    team    = "shared"
    network = "public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.team_public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private_public" {
  vpc_id = aws_vpc.team_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.team.id
  }

  route {
    cidr_block                = "172.16.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name    = "team-networked-route-table"
    team    = "shared"
    network = "private-public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.team_vpc.id

  route {
    cidr_block                = "172.16.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name    = "team-private-route-table"
    team    = "shared"
    network = "private"
  }
}

resource "aws_security_group" "blue_team_all" {
  name        = "blue-team-sg"
  description = "Allow access in and out for all blue team servers"
  vpc_id      = aws_vpc.team_vpc.id

  ingress {
    description = "Allow all in"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "blue-team-sg"
    team = "shared"
  }
}
