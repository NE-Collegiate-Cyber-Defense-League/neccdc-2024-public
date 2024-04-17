locals { timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp()) }

source "amazon-ebs" "vm" {
  region        = "us-east-2"
  ami_name      = "packer-gitlab-${local.timestamp}"
  source_ami    = "ami-05fb0b8c1424f266b" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-12-07
  instance_type = "t3a.medium"

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

  associate_public_ip_address = true

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 50
    delete_on_termination = true
  }

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  tags = {
    "Name" = "packer-gitlab"
    "date" = "${local.timestamp}"
  }
  run_tags = {
    "Name" = "packer-temporary-build-server"
  }
}
