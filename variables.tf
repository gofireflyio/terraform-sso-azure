variable "domain" {
  type = string
}

variable "user_emails" {
  type = list(string)
}

variable "app_name" {
  type    = string
  default = "Firefly"
}
