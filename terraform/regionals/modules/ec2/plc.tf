resource "aws_security_group" "plc" {
  name        = "plc"
  description = "Allow access in and out of PLC"
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
    Name = "plc"
  }
}

resource "aws_instance" "plc" {
  ami           = data.aws_ami.packer-plc.id
  instance_type = "t3a.small"
  subnet_id     = var.subnet_private_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["plc"], null)

  private_ip = "10.${var.team_number}.169.169"

  vpc_security_group_ids = [
    aws_security_group.plc.id
  ]

  tags = {
    Name      = "plc"
    service   = "plc"
    scheduled = "false"
  }
}
