variable "team_number" {
  type        = number
  description = "Team number"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Default tags to apply to all resources"
}

variable "security_team" {
  type = list(string)
  default = [
    "rmalek",
    "cslater",
    "cchaikin"
  ]
}

variable "admins" {
  type = list(string)
  default = [
    "bcallahan",
    "iortega",
    "llubin",
    "lgraves",
    "lknight",
    "mbrown",
    "wleffel"
  ]
}

variable "it_team" {
  type = list(string)
  default = [
    "ejohnson",
    "emitchell",
    "fgaiter",
    "hfaller",
    "jblack",
    "lmorse",
    "lpoteet",
    "mcarlson",
    "rhooser",
    "revans",
    "sbusch",
    "shummel",
    "valcorn",
    "vseitz"
  ]
}

variable "product_team" {
  type = list(string)
  default = [
    "cperry",
    "cpetti",
    "dmyers",
    "dparkes",
    "fyazzie",
    "ghayden",
    "jwester",
    "kcrafton",
    "lbrown",
    "rwotring",
    "sgutierrez"
  ]
}

variable "sales_team" {
  type = list(string)
  default = [
    "aratliff",
    "cloucks",
    "emcdonald",
    "fgutierrez",
    "fmckenna",
    "jmuir",
    "lfrick",
    "nhood",
    "rmartin",
    "solson",
    "tshannon"
  ]
}

variable "qa_team" {
  type = list(string)
  default = [
    "acovington",
    "dgaliano",
    "fcheng",
    "glopez",
    "ihamlin"
  ]
}

variable "number_of_blue_users" {
  type        = number
  default     = 8
  description = "description"
}

variable "account_id" {
  type        = number
  description = "Blue team account id"
}
