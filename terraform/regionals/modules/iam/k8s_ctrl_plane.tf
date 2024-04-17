resource "aws_iam_role" "kubernetes_control_plane" {
  name = "kubernetes_control_plane"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    aws_iam_policy.kubernetes_policy.arn
  ]
}

resource "aws_iam_instance_profile" "kubernetes_control_plane" {
  name = "kubernetes_control_plane"
  role = aws_iam_role.kubernetes_control_plane.name
}
