resource "aws_security_group" "win_client" {
  name        = "win_client"
  description = "Allow access in and out of win_client"
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
    Name = "win_client"
  }
}

resource "aws_instance" "win_work_01" {
  ami           = data.aws_ami.windows_client.image_id
  instance_type = "t3a.large"
  subnet_id     = var.subnet_ad_corp_id

  key_name = var.key_pair
  # iam_instance_profile = var.instance_profile

  private_ip = "10.${var.team_number}.13.37"

  vpc_security_group_ids = [
    aws_security_group.win_client.id
  ]

  tags = {
    Name      = "win_client1"
    service   = "win_client1"
    scheduled = "false"
  }
}

resource "aws_instance" "win_work_02" {
  ami           = data.aws_ami.windows_client.image_id
  instance_type = "t3a.large"
  subnet_id     = var.subnet_ad_corp_id

  key_name = var.key_pair
  # iam_instance_profile = var.instance_profile

  private_ip = "10.${var.team_number}.22.222"

  vpc_security_group_ids = [
    aws_security_group.win_client.id
  ]

  tags = {
    Name      = "win_client2"
    service   = "win_client2"
    scheduled = "false"
  }
}