resource "aws_subnet" "ad_corp" {
  vpc_id                  = var.team_vpc_id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.0.${var.team_number}.0/25"

  tags = merge(var.default_tags, {
    Name    = "${var.team_number}-ad-corp"
    network = "public"
  })
}

resource "aws_subnet" "id_corp" {
  vpc_id                  = var.team_vpc_id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.0.${var.team_number}.128/26"

  tags = merge(var.default_tags, {
    Name    = "${var.team_number}-id-corp"
    network = "public"
  })
}

resource "aws_subnet" "kubernetes" {
  vpc_id                  = var.team_vpc_id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.0.${var.team_number}.192/27"

  tags = merge(var.default_tags, {
    Name    = "${var.team_number}-kubernetes"
    network = "public"
  })
}

resource "aws_subnet" "private" {
  vpc_id                  = var.team_vpc_id
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  cidr_block              = "10.0.${var.team_number}.240/28"

  tags = merge(var.default_tags, {
    Name    = "${var.team_number}-private"
    network = "private"
  })
}
