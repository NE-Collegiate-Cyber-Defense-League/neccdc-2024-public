resource "aws_security_group" "kubernetes_worker_node_3" {
  name        = "kubernetes_worker_node_3"
  description = "Allow access in and out of k8s worker node"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow all in"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all out"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "kubernetes_worker_node_3"
  }
}

resource "aws_instance" "kubernetes_worker_node_3" {
  ami           = data.aws_ami.kubernetes_containerd.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.subnet_kubernetes_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["k8s_worker_2"], null)

  private_ip = "10.${var.team_number}.192.244"

  vpc_security_group_ids = [
    aws_security_group.kubernetes_worker_node_3.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }

  tags = {
    Name      = "worker node 3"
    service   = "kubernetes"
    scheduled = "false"
  }
}
