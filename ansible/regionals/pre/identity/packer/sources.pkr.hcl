locals { timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp()) }

source "amazon-ebs" "vm" {
  region        = "us-east-2"
  ami_name      = "packer-identity-${local.timestamp}"
  source_ami    = "ami-0931978297f275f71" # RHEL 9
  instance_type = "t3a.2xlarge"

  vpc_filter {
    filters = {
      "tag:Name" : "black-team",
      "tag:path": "terraform/regionals/environments/black_team"
    }
  }

  subnet_filter {
    filters = {
      "tag:Name" : "black-team-public-us-east-2a"
    }
  }

  security_group_filter {
    filters = {
      "tag:Name" : "packer",
      "tag:path": "terraform/regionals/environments/black_team"
    }
  }

  associate_public_ip_address = true

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    delete_on_termination = true
  }

  tags = {
    "Name" = "packer-identity"
    "Date" = "${local.timestamp}"
  }
  run_tags = {
    "Name" = "packer-temporary-build-server"
  }
}
