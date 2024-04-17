output "subnet_ad_corp_id" {
  value = aws_subnet.ad_corp.id
}

output "subnet_id_corp_id" {
  value = aws_subnet.id_corp.id
}

output "subnet_kubernetes_id" {
  value = aws_subnet.kubernetes.id
}

output "subnet_private_id" {
  value = aws_subnet.private.id
}

output "vpc_id" {
  value       = aws_vpc.team_vpc.id
  description = "ID of the blue team vpc"
}
