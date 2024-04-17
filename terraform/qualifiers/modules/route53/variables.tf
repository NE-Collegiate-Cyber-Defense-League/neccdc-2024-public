variable "team_number" {
  type        = number
  description = "Team number"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources"
}

variable "records" {
  description = "A map of A records"
  type = map(string)
}