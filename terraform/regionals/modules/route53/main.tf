resource "aws_route53_record" "kubernets_wildcard" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "*.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.192.211",
    "10.${var.team_number}.192.222",
    "10.${var.team_number}.192.233",
    "10.${var.team_number}.192.244"
  ]
}

resource "aws_route53_record" "vault" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "vault.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.128.182"
  ]
}

resource "aws_route53_record" "wazuh" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "wazuh.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.128.254"
  ]
}

resource "aws_route53_record" "identity" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "idm.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.128.132"
  ]
}

resource "aws_route53_record" "gitlab" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "gitlab.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.128.192"
  ]
}

resource "aws_route53_record" "gitlab_registry" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "registry.${var.team_number}.${data.aws_route53_zone.public.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.${var.team_number}.128.192"
  ]
}
