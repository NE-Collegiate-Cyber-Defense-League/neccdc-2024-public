resource "aws_security_group" "kubernetes_worker_node_2" {
  name        = "kubernetes_worker_node_2"
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
    Name = "kubernetes_worker_node_2"
  }
}

resource "aws_instance" "kubernetes_worker_node_2" {
  ami           = data.aws_ami.kubernetes_docker.image_id
  instance_type = "t3a.medium"
  subnet_id     = var.subnet_kubernetes_id

  key_name             = var.key_pair
  iam_instance_profile = try(var.instance_profiles["k8s_worker_2"], null)

  private_ip = "10.${var.team_number}.192.233"

  vpc_security_group_ids = [
    aws_security_group.kubernetes_worker_node_2.id
  ]

  tags = {
    Name      = "worker node 2"
    service   = "kubernetes"
    scheduled = "false"
  }
}
