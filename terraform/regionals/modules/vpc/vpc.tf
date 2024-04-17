resource "aws_vpc" "team_vpc" {
  cidr_block = "10.${var.team_number}.0.0/16"

  tags = {
    Name = "RustEnergyVPC"
  }
}

resource "aws_internet_gateway" "team" {
  vpc_id = aws_vpc.team_vpc.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "team" {
  depends_on = [
    aws_internet_gateway.team
  ]

  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id

  tags = {
    Name = "nat-gateway"
  }
}
