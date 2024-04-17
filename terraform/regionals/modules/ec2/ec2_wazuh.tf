resource "aws_security_group" "wazuh" {
  name        = "wazuh"
  description = "Allow access in and out of Wazuh"
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
    Name = "wazuh"
  }
}

resource "aws_instance" "wazuh" {
  ami           = data.aws_ami.wazuh.id
  instance_type = "t3a.large"
  subnet_id     = var.subnet_id_corp_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["wazuh"], null)

  private_ip = "10.${var.team_number}.128.254"

  vpc_security_group_ids = [
    aws_security_group.wazuh.id
  ]

  tags = {
    Name      = "wazuh"
    service   = "wazuh"
    scheduled = "false"
  }
}
