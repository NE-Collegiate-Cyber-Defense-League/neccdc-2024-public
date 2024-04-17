locals {
  team_number = terraform.workspace
  default_tags = {
    team = local.team_number
  }
}

module "network" {
  source = "../../modules/network"

  team_number  = local.team_number
  default_tags = local.default_tags

  team_vpc_id = data.aws_vpc.team_team.id

  networked_route_table_id = data.aws_route_table.team_networked.route_table_id
  private_route_table_id   = data.aws_route_table.team_private.route_table_id
}

module "ec2" {
  source = "../../modules/ec2"

  team_number  = local.team_number
  default_tags = local.default_tags

  team_subnet_ad_id      = module.network.subnet_ad_corp_id
  team_subnet_id_id      = module.network.subnet_id_corp_id
  team_subnet_k8s_id     = module.network.subnet_kubernetes_id
  team_subnet_private_id = module.network.subnet_private_id

  security_group_id = data.aws_security_group.team.id
  key_pair          = data.aws_key_pair.black_team.key_name
  instance_profile  = "only_ssm"
}

module "route53" {
  source = "../../modules/route53"

  team_number  = local.team_number
  records = {}
}