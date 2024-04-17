resource "aws_route53_record" "score" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "score.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.score.public_ip]
}

resource "aws_eip" "score" {
  domain   = "vpc"
  instance = aws_instance.scorestack.id

  tags = {
    Name = "scorestack"
  }
}

resource "aws_instance" "scorestack" {
  ami                         = "ami-0e83be366243f524a" # Currently ubuntu
  instance_type               = "t3a.2xlarge"
  iam_instance_profile        = aws_iam_instance_profile.only_ssm.id
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.scorestack.id]
  associate_public_ip_address = true
  private_ip                  = "172.16.128.1"
  key_name                    = aws_key_pair.black_team.id

  root_block_device {
    volume_type = "gp3"
    volume_size = 80
    iops        = 6000
    throughput  = 400
  }

  tags = {
    Name = "scorestack"
  }
}

resource "aws_security_group" "scorestack" {
  name        = "scorestack"
  description = "Allow traffic in and out of scorestack"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH into scorestack"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Team scorestack Web HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Team scorestack Web HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Team scorestack Web"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internal Full Access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/16"]
  }

  ingress {
    description = "Team scorestack ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Elastic API"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Full Egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "scorestack"
  }
}