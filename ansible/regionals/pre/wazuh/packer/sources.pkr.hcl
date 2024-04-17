locals { timestamp = formatdate("YYYY-MM-DD-hh-mm", timestamp()) }

source "amazon-ebs" "vm" {
  region        = "us-east-2"
  ami_name      = "packer-wazuh-${local.timestamp}"
  source_ami    = "ami-0931978297f275f71" # RHEL-9.2.0_HVM-20230905-x86_64-38-Hourly2-GP2
  instance_type = "t3a.large"

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
    volume_size           = 60
    delete_on_termination = true
  }

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  tags = {
    "Name" = "packer-wazuh"
    "date" = "${local.timestamp}"
  }
  run_tags = {
    "Name" = "packer-temporary-build-server"
  }
}
