data "aws_route53_zone" "rust_energy" {
  name         = "rust.energy."
  private_zone = true
}
