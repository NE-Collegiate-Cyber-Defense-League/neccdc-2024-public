terraform {
  required_version = "1.7.2"

  backend "s3" {
    bucket = "neccdl-2024-bucket-name"
    key    = "regionals/managment/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  assume_role {
    role_arn     = "arn:aws:iam::0123456789:role/management-account-role-name"
    session_name = "black-team-terraform"
  }

  default_tags {
    tags = {
      terraform = "true"
      path      = "terraform/regionals/environments/managment_account"
    }
  }
}
