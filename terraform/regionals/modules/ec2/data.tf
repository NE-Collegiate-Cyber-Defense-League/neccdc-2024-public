data "aws_ami" "kubernetes_ctrl" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-kubernetes-base-ctrl-*"]
  }
}

data "aws_ami" "kubernetes_docker" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-kubernetes-base-docker-*"]
  }
}

data "aws_ami" "kubernetes_containerd" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-kubernetes-base-containerd-*"]
  }
}

data "aws_ami" "identity" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-identity*"]
  }
}

data "aws_ami" "gitlab" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-gitlab*"]
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

data "aws_ami" "windows_client" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-windows-client*"]
  }
}

data "aws_ami" "windows_server_gui" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-windows-server-gui*"]
  }
}

data "aws_ami" "windows_server_core" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-windows-server-core*"]
  }
}

data "aws_ami" "packer-plc" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-plc*"]
  }
}
