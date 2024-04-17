locals {
  plc_relay_ip = "172.20.1.100"
}

resource "aws_route53_record" "plc_relay" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "plc-relay.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [local.plc_relay_ip]
}

resource "aws_security_group" "plc_relay" {
  name        = "plc_relay"
  description = "Allow access in and out of PLC Relay"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all in"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/12", "10.0.0.0/8"]
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
    Name = "plc_relay"
  }
}

resource "aws_instance" "plc_relay" {
  ami                    = "ami-004174f06aa975" # PLC relay image
  instance_type          = "t3a.medium"
  iam_instance_profile   = aws_iam_instance_profile.only_ssm.id
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.plc_relay.id]

  private_ip = local.plc_relay_ip
  key_name   = aws_key_pair.black_team.id

  tags = {
    Name = "plc_relay"
  }
}
