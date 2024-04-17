variable "team_number" {
  type        = number
  description = "Team number"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources"
}

variable "vpc_id" {
  type        = string
  description = "ID of the blue team vpc"
}

variable "subnet_ad_corp_id" {
  type = string
}

variable "subnet_id_corp_id" {
  type = string
}

variable "subnet_kubernetes_id" {
  type = string
}

variable "subnet_private_id" {
  type = string
}

variable "key_pair" {
  type        = string
  default     = "black-team"
  description = "Key pair to use for all instances"
}

variable "instance_profiles" {
  type        = map(string)
  default     = {}
  description = "List of IAM instance profiles"
}
