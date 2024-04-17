output "blue_team_key_name" {
  value       = aws_key_pair.blue_team_key.key_name
  description = "Name of the blue team keypair"
}
