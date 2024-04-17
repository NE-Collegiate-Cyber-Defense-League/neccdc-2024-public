variable "team_number" {
  type        = number
  description = "Team number"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources"
}

variable "team_subnet_ad_id" {
  type        = string
  description = "Team ad subnet id"
}

variable "team_subnet_id_id" {
  type        = string
  description = "Team id subnet id"
}

variable "team_subnet_k8s_id" {
  type        = string
  description = "Team k8s subnet id"
}

variable "team_subnet_private_id" {
  type        = string
  description = "Team private subnet id"
}

variable "security_group_id" {
  type        = string
  description = "Security group to use for EC2 instances"
}

variable "key_pair" {
  type        = string
  description = "Name of the key pair to use"
}

variable "instance_profile" {
  type        = string
  description = "IAM instance profile to use for the instances to allow SSM"
}