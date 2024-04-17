resource "aws_instance" "wazuh" {
  ami           = data.aws_ami.wazuh.image_id
  instance_type = "t3a.large"
  subnet_id     = var.team_subnet_id_id

  key_name             = var.key_pair
  iam_instance_profile = "Wazuh"

  private_ip = "10.0.${var.team_number}.180"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name    = "team${var.team_number}_wazuh"
    Hostname = "wazuh"
    Service = "Wazuh"
  })
}
