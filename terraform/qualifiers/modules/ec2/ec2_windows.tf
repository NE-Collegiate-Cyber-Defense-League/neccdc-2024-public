# Not sure if this needs to be added to resources yet
#private_dns_name_options {
#  enable_resource_name_dns_a_record = true
#}

resource "aws_instance" "dc_01" {
  ami           = data.aws_ami.windows_server.image_id
  instance_type = "t3a.large"
  subnet_id     = var.team_subnet_ad_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.16"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_dc-01"
    Hostname = "dc-01"
    Service  = "Windows"
  })
}

resource "aws_instance" "ca" {
  ami           = data.aws_ami.windows_server.image_id
  instance_type = "t3a.large"
  subnet_id     = var.team_subnet_ad_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip            = "10.0.${var.team_number}.32"
  secondary_private_ips = ["10.0.${var.team_number}.64"] # 😅

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_ca"
    Hostname = "ca"
    Service  = "Windows"
  })
}

resource "aws_instance" "win_01" {
  ami           = data.aws_ami.windows_client.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.team_subnet_ad_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.100"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_win-01"
    Hostname = "win-01"
    Service  = "Windows"
  })
}

resource "aws_instance" "win_02" {
  ami           = data.aws_ami.windows_client.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.team_subnet_ad_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.110"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_win-02"
    Hostname = "win-02"
    Service  = "Windows"
  })
}
