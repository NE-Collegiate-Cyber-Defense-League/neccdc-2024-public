terraform {
  required_version = "~> 1.6.2"

  backend "s3" {
    bucket = "neccdl-2024-bucket-name"
    key    = "qualifiers/black_team/terraform.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.22.0"
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
  default_tags {
    tags = {
      terraform = "true"
      path      = "terraform/qualifiers/environments/black_team"
    }
  }
}

provider "acme" {
  # Staging endpoint https://acme-staging-v02.api.letsencrypt.org/directory
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
