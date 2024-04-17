resource "aws_network_acl" "team" {
  vpc_id = var.team_vpc_id

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.${var.team_number}.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 101
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 102
    action     = "allow"
    cidr_block = "10.1.1.0/24"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 103
    action     = "deny"
    cidr_block = "10.0.0.0/16"
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
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(var.default_tags, {
    Name = "${var.team_number}-nacl"
  })
}

resource "aws_network_acl_association" "ad_corp" {
  subnet_id      = aws_subnet.ad_corp.id
  network_acl_id = aws_network_acl.team.id
}

resource "aws_network_acl_association" "id_corp" {
  subnet_id      = aws_subnet.id_corp.id
  network_acl_id = aws_network_acl.team.id
}

resource "aws_network_acl_association" "kubernetes" {
  subnet_id      = aws_subnet.kubernetes.id
  network_acl_id = aws_network_acl.team.id
}

resource "aws_network_acl_association" "private" {
  subnet_id      = aws_subnet.private.id
  network_acl_id = aws_network_acl.team.id
}
