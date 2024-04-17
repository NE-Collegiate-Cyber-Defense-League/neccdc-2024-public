resource "aws_route53_record" "records" {
  for_each = var.records

  zone_id = data.aws_route53_zone.rust_energy.zone_id
  name    = "${each.key}.${var.team_number}.${data.aws_route53_zone.rust_energy.name}"
  type    = "A"
  ttl     = "300"
  records = [each.value]
}

resource "aws_route53_record" "kubernets_wildcard" {
  zone_id = data.aws_route53_zone.rust_energy.zone_id
  name    = "*.${var.team_number}.${data.aws_route53_zone.rust_energy.name}"
  type    = "A"
  ttl     = "300"
  records = [
    "10.0.${var.team_number}.200",
    "10.0.${var.team_number}.210",
    "10.0.${var.team_number}.220"
  ]
}
