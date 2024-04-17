locals {
  teams = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "99"
  ]
}

module "certificates" {
  source = "../../modules/certificates"

  for_each = toset(local.teams)

  domain_name = "rust.energy"
  output_dir  = "../../../../documentation/certs/regionals/"
  team_number = each.key
}
