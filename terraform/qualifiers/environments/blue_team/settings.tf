terraform {
  required_version = "~> 1.6.2"

  backend "s3" {
    bucket               = "neccdl-2024-bucket-name"
    key                  = "terraform.tfstate"
    region               = "us-east-2"
    workspace_key_prefix = "qualifiers/blue_team"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}
