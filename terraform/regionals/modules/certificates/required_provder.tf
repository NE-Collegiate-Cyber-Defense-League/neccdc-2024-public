terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = ">= 2.10.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
    }
  }
}
