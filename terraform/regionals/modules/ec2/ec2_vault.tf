resource "aws_security_group" "vault" {
  name        = "vault"
  description = "Allow access in and out of Vault"
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
    Name = "vault"
  }
}

resource "aws_instance" "vault" {
  ami           = data.aws_ami.vault.id
  instance_type = "t3a.small"
  subnet_id     = var.subnet_id_corp_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["vault"], null)

  private_ip = "10.${var.team_number}.128.182"

  vpc_security_group_ids = [
    aws_security_group.vault.id
  ]

  tags = {
    Name      = "vault"
    service   = "vault"
    scheduled = "false"
  }
}
