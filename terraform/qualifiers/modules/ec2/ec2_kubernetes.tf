resource "aws_instance" "controlle_plane_node" {
  ami           = data.aws_ami.kubernetes_control_node.image_id
  instance_type = "t3a.small"
  subnet_id     = var.team_subnet_k8s_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.200"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_controlle-plane-node"
    Hostname = "controlle-plane-node"
    Service  = "kubernetes"
  })
}

resource "aws_instance" "worker_node_1" {
  ami           = data.aws_ami.kubernetes_base.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.team_subnet_k8s_id

  key_name             = var.key_pair
  iam_instance_profile = var.instance_profile

  private_ip = "10.0.${var.team_number}.210"

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_worker-node-1"
    Hostname = "worker-node-1"
    Service  = "kubernetes"
  })
}

resource "aws_instance" "worker_node_2" {
  ami           = data.aws_ami.kubernetes_base.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.team_subnet_k8s_id

  key_name = var.key_pair

  private_ip           = "10.0.${var.team_number}.220"
  iam_instance_profile = var.instance_profile

  vpc_security_group_ids = [
    var.security_group_id
  ]

  tags = merge(var.default_tags, {
    Name     = "team${var.team_number}_worker-node-2"
    Hostname = "worker-node-2"
    Service  = "kubernetes"
  })
}
