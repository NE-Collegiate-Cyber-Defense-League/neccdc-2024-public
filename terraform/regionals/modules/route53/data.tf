# data "aws_route53_zone" "private" {
#   name         = "rust.energy."
#   private_zone = true
# }

data "aws_route53_zone" "public" {
  name         = "rust.energy."
  private_zone = false
}