locals { timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp()) }

source "amazon-ebs" "vm" {
  region        = "us-east-2"
  ami_name      = "packer-vault-${local.timestamp}"
  source_ami    = "ami-020d80dea4f225640" # FreeBSD 13 AMI
  instance_type = "t3a.2xlarge"

  vpc_filter {
    filters = {
      "tag:Name" : "black-team"
    }
  }

  subnet_filter {
    filters = {
      "tag:Name" : "black-team-public-us-east-2a"
    }
  }

  security_group_filter {
    filters = {
      "tag:Name" : "packer"
    }
  }

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  associate_public_ip_address = true

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 30
    delete_on_termination = true
  }

  tags = {
    "Name" = "packer-vault"
    "date" = "${local.timestamp}"
  }
  run_tags = {
    "Name" = "packer-temporary-build-server"
  }
}
