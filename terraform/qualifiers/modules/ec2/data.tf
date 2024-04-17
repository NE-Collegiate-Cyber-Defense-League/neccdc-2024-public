data "aws_ami" "kubernetes_control_node" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-kubernetes-control-plane-*"]
  }
}

data "aws_ami" "kubernetes_base" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-kubernetes-base-*"]
  }
}

data "aws_ami" "windows_server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-windows-server*"]
  }
}

data "aws_ami" "windows_client" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-windows-client*"]
  }
}

data "aws_ami" "plc" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-plc-*"]
  }
}

data "aws_ami" "packer_identity" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-identity*"]
  }
}

data "aws_ami" "vault" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-vault*"]
  }
}

data "aws_ami" "wazuh" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-wazuh*"]
  }
}

data "aws_ami" "semaphore" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-semaphore*"]
  }
}