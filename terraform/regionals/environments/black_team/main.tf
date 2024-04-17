# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name                  = "black-team"
  cidr                  = "172.16.0.0/16"
  secondary_cidr_blocks = ["172.20.0.0/16"]

  azs             = ["us-east-2a"]
  public_subnets  = ["172.16.0.0/16"]
  private_subnets = ["172.20.0.0/17"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  vpc_tags = {
    competition = "regionals"
  }

  nat_gateway_tags = {
    Name = "black-team"
  }
}

resource "aws_security_group" "packer" {
  name        = "packer"
  description = "Allow packer to configure hosts"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "More SSH for K8s"
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow WinRM HTTP/HTTPS"
    from_port   = 5985
    to_port     = 5986
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internal Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.16.0.0/16"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "packer"
  }
}
