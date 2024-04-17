module "iam" {
  count = (terraform.workspace == "0" || terraform.workspace == "99") ? 0 : 1

  source = "../../modules/iam"

  account_id          = data.aws_caller_identity.blue.id
  team_number         = terraform.workspace
}

module "account" {
  count = (terraform.workspace == "0" || terraform.workspace == "99") ? 0 : 1

  source = "../../modules/account"

  team_number          = terraform.workspace
  blue_team_access_key = "../../../../documentation/blue_team_access/regionals/id_rsa.pub"
  black_team_key       = "../../../../documentation/black_team/black-team.pub"
}

module "cloudtrail" {
  count = (terraform.workspace == "0" || terraform.workspace == "99") ? 0 : 1

  source = "../../modules/cloudtrail"

  team_number = terraform.workspace
}

# Depends on black team deployment
module "vpc" {
  source = "../../modules/vpc"

  providers = {
    aws       = aws
    aws.black = aws.black
  }

  team_number = terraform.workspace
}

locals {
  iam_instance_profiles = {
    gitlab         = "only_ssm"
    identity       = "only_ssm"
    k8s_ctrl_plane = "only_ssm"
    k8s_worker_1   = "only_ssm"
    k8s_worker_2   = "only_ssm"
    k8s_worker_3   = "only_ssm"
    plc            = "only_ssm"
    vault          = "only_ssm"
    wazuh          = "only_ssm"
  }
}

module "ec2" {
  source = "../../modules/ec2"

  team_number = terraform.workspace
  vpc_id      = module.vpc.vpc_id

  instance_profiles = try(module.iam[0].server_instance_profiles, local.iam_instance_profiles)

  key_pair = try(module.account[0].blue_team_key_name, "black-team")

  subnet_ad_corp_id    = module.vpc.subnet_ad_corp_id
  subnet_id_corp_id    = module.vpc.subnet_id_corp_id
  subnet_kubernetes_id = module.vpc.subnet_kubernetes_id
  subnet_private_id    = module.vpc.subnet_private_id
}

module "dns" {
  source = "../../modules/route53"

  providers = {
    aws = aws.black
  }

  team_number = terraform.workspace
}
