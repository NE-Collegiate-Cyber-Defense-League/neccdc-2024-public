variable "team_number" {
  type        = number
  description = "Team number"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources"
}

variable "team_vpc_id" {
  type        = string
  description = "Team vpc id"
}

variable "private_route_table_id" {
  type        = string
  description = "description"
}

variable "networked_route_table_id" {
  type        = string
  description = "description"
}
