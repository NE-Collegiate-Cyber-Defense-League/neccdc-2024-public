variable "team_number" {
  type        = number
  description = "Team number"
}

variable "blue_team_access_key" {
  type        = string
  description = "Path to the blue team public key"
}

variable "black_team_key" {
  type        = string
  description = "Black team key"
}


variable "default_tags" {
  type        = map(string)
  default     = {
    WARNING = "Black team dont dare touch"
  }
  description = "Default tags to apply to all resources"
}
