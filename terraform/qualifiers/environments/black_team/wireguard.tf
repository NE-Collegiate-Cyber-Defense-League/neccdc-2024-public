data "aws_route53_zone" "selected" {
  name         = "rust.energy."
  private_zone = false
}

resource "aws_route53_record" "vpn" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "vpn.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.eip.public_ip]
}

resource "aws_eip" "eip" {
  domain   = "vpc"
  instance = aws_instance.wireguard.id

  tags = {
    Name = "wireguard"
  }
}

resource "aws_instance" "wireguard" {
  ami           = "ami-0e83be366243f524a" # Currently ubuntu
  instance_type = "t3.large"

  iam_instance_profile = aws_iam_instance_profile.only_ssm.id

  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.wireguard.id]
  associate_public_ip_address = true
  private_ip                  = "172.16.127.1"

  key_name = aws_key_pair.black_team.id

  tags = {
    Name = "wireguard"
  }
}

resource "aws_security_group" "wireguard" {
  name        = "wireguard"
  description = "Allow traffic in and out of wireguard"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "BlackTeam Wireguard UDP"
    from_port   = 51899
    to_port     = 51899
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "BlackTeam Wireguard TCP"
    from_port   = 51999
    to_port     = 51999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH into wireguard"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Only used for initial creation
  ingress {
    description = "Team Wireguard Web TCP"
    from_port   = 51800
    to_port     = 52000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Team Wireguard UDP"
    from_port   = 51800
    to_port     = 52000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "wireguard"
  }
}
