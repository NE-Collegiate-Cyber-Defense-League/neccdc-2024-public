terraform {
  required_version = "1.7.2"

  backend "s3" {
    bucket = "neccdl-2024-bucket-name"
    key    = "regionals/black_team/terraform.tfstate"
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
  default_tags {
    tags = {
      terraform = "true"
      path      = "terraform/regionals/environments/black_team"
    }
  }
}