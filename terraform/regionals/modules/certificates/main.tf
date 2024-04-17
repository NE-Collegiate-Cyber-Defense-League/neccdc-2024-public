resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "aaiken+acme@neccdl.org"
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = "*.${var.team_number}.${var.domain_name}"

  dns_challenge {
    provider = "route53"
  }
}

resource "local_file" "private_key_pem" {
  content  = acme_certificate.certificate.private_key_pem
  filename = "${var.output_dir}/team_${var.team_number}/private.key"
}

resource "local_file" "issuer" {
  content  = acme_certificate.certificate.issuer_pem
  filename = "${var.output_dir}/team_${var.team_number}/cabundle.crt"
}

resource "local_file" "cert" {
  content  = acme_certificate.certificate.certificate_pem
  filename = "${var.output_dir}/team_${var.team_number}/cert.crt"
}

resource "local_file" "fullchain" {
  content  = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
  filename = "${var.output_dir}/team_${var.team_number}/fullchain.crt"
}

resource "local_file" "fullerchain" { # 😏
  content  = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}${file("${path.module}/files/letsencrypt.crt")}"
  filename = "${var.output_dir}/team_${var.team_number}/fullerchain.crt"
}
