# https://www.packer.io/plugins/builders/amazon/ebs
source "amazon-ebs" "vm" {
  assume_role {
    role_arn     = "arn:aws:iam::0123456789:role/black-team"
    session_name = "packer-ansible-k8s"
  }

  region            = "us-east-2"
  ami_name          = "packer-plc-${formatdate("YYYY-MMM-DD-hh-mm", timestamp())}"
  subnet_id         = "subnet-01ca319db439fb36c"
  security_group_id = "sg-0df10026da76f5310"

  source_ami                  = "ami-05abf454d39ca742f" # openSUSE-Leap-15-5-v20231210-hvm-ssd-x86_64-5535c495-72d4-4355-b169-54ffa874f849
  instance_type               = "t3.small"
  associate_public_ip_address = true

  ami_org_arns = [
    "arn:aws:organizations::123456789012:organization/o-123456789012"
  ]

  tags = {
    Name = "packer-plc"
    date = formatdate("YYYY-MM-DD hh:mm", timestamp())
    comp = "regionals"
  }
  run_tags = {
    Name    = "packer-temporary-build-server"
    date    = formatdate("YYYY-MM-DD hh:mm", timestamp())
    service = "plc"
  }
}
