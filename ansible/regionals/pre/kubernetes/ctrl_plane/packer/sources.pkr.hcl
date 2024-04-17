# https://www.packer.io/plugins/builders/amazon/ebs
source "amazon-ebs" "vm" {
  region            = "us-east-2"
  ami_name          = "packer-kubernetes-base-ctrl-${formatdate("YYYY-MMM-DD-hh-mm", timestamp())}"
  subnet_id         = "subnet-01ca319db439fb36c"
  security_group_id = "sg-0df10026da76f5310"

  source_ami                  = "ami-05f9e6b3" # Containerd image from other pre k8s build
  instance_type               = "t3a.small"
  associate_public_ip_address = true

  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 32
    delete_on_termination = true
  }

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  tags = {
    Name    = "packer-kubernetes-base-ctrl"
    date    = formatdate("YYYY-MM-DD hh:mm", timestamp())
    comp    = "regionals"
    runtime = "containerd"
  }

  run_tags = {
    Name      = "packer-temporary-build-server"
    component = "ctrl"
    date      = formatdate("YYYY-MM-DD hh:mm", timestamp())
    service   = "kubernetes"
    runtime   = "containerd"
  }
}
