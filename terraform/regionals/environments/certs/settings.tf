terraform {
  required_version = "1.7.2"

  backend "s3" {
    bucket               = "neccdl-2024-bucket-name"
    key                  = "regionals/certs/terraform.tfstate"
    region               = "us-east-2"

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
    acme = {
      source  = "vancluever/acme"
      version = "2.10.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.1"
    }
  }
}


provider "aws" {
  region = "us-east-2"

  assume_role {
    role_arn     = "arn:aws:iam::0123456789:role/black-team"
    session_name = "black-team-terraform"
  }

  default_tags {
    tags = {
      terraform = "true"
      path      = "terraform/regionals/environments/certs"
    }
  }
}

provider "acme" {
  # Staging endpoint 
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"

  # Production endpoint
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
