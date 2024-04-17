locals {
  env = {
    default = {
      aws_region = "us-east-2"
    }
    "0" = {
      account_id = "0123456789"
    }
    "1" = {
      account_id = "0123456789"
    }
    "2" = {
      account_id = "0123456789"
    }
    "3" = {
      account_id = "0123456789"
    }
    "4" = {
      account_id = "0123456789"
    }
    "5" = {
      account_id = "0123456789"
    }
    "6" = {
      account_id = "0123456789"
    }
    "7" = {
      account_id = "0123456789"
    }
    "8" = {
      account_id = "0123456789"
    }
    "9" = {
      account_id = "0123456789"
    }
    "10" = {
      account_id = "0123456789"
    }
    "99" = {
      account_id = "0123456789"
    }
  }
  environmentvars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace       = merge(local.env["default"], local.env[local.environmentvars])
}
