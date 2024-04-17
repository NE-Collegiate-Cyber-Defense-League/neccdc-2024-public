terraform {
  required_version = "1.7.2"

  backend "s3" {
    bucket               = "neccdl-2024-bucket-name"
    key                  = "terraform.tfstate"
    region               = "us-east-2"
    workspace_key_prefix = "regionals/blue_team"

    assume_role = {
      role_arn     = "arn:aws:iam::0123456789:role/black-team"
      session_name = "black-team-terraform-state"
    }
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
    role_arn     = "arn:aws:iam::${local.workspace["account_id"]}:role/black-team"
    session_name = "black-team-${terraform.workspace}-terraform"
  }

  # Commented for comp
  # default_tags {
  #   tags = {
  #     terraform = "true"
  #     path      = "terraform/regionals/environments/blue_team"
  #     team      = terraform.workspace
  #   }
  # }
}

provider "aws" {
  alias  = "black"
  region = "us-east-2"

  assume_role {
    role_arn     = "arn:aws:iam::0123456789:role/black-team"
    session_name = "black-team-terraform"
  }

  default_tags {
    tags = {
      terraform = "true"
      path      = "terraform/regionals/environments/blue_team"
      team      = terraform.workspace
    }
  }
}
