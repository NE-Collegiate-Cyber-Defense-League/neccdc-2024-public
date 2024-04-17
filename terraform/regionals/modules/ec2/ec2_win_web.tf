resource "aws_security_group" "win_web" {
  name        = "win_web"
  description = "Allow access in and out of win_web"
  vpc_id      = var.vpc_id

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
    Name = "win_web"
  }
}

resource "aws_instance" "win_web" {
  ami           = data.aws_ami.windows_server_gui.image_id
  instance_type = "t3a.large"
  subnet_id     = var.subnet_ad_corp_id

  key_name = var.key_pair
  # iam_instance_profile = var.instance_profile

  private_ip = "10.${var.team_number}.25.200"

  vpc_security_group_ids = [
    aws_security_group.win_web.id
  ]

  tags = {
    Name      = "win_web"
    service   = "win_web"
    scheduled = "true"
  }
}