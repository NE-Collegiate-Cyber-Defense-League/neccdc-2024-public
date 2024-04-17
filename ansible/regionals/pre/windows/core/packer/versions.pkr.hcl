# https://github.com/hashicorp/packer-plugin-amazon
# https://github.com/hashicorp/packer-plugin-ansible

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1.2.0"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1.0"
    }
  }
}