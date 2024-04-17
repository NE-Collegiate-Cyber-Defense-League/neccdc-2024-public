resource "aws_security_group" "gitlab" {
  name        = "gitlab"
  description = "Allow access in and out of GitLab"
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
    Name = "gitlab"
  }
}

resource "aws_instance" "gitlab" {
  ami           = data.aws_ami.gitlab.id
  instance_type = "t3a.large"
  subnet_id     = var.subnet_id_corp_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["gitlab"], null)

  private_ip = "10.${var.team_number}.128.192"

  vpc_security_group_ids = [
    aws_security_group.gitlab.id
  ]

  tags = {
    Name      = "gitlab"
    service   = "gitlab"
    scheduled = "false"
  }
}
