variable "domain" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "firefly_users_emails" {
  type    = list(string)
  default = []
}

variable "app_name" {
  type    = string
  default = "Firefly"
}

variable "create_admins_group" {
  type    = bool
  default = false
}

variable "create_viewers_group" {
  type    = bool
  default = false
}

variable "new_admins_group_name" {
  type    = string
  default = "Firefly-Admins"
}

variable "new_viewers_group_name" {
  type    = string
  default = "Firefly-Viewers"
}

variable "existing_admins_group_name" {
  type    = string
  default = ""
}

variable "existing_viewers_group_name" {
  type    = string
  default = ""
}