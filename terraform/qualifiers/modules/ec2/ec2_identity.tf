resource "aws_instance" "identity" {
  ami           = data.aws_ami.packer_identity.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.team_subnet_id_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.132"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_idm"
    Hostname = "idm"
    Service  = "Identity"
  })
}
