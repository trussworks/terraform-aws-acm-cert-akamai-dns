variable "alb_listener_arn" {
  type        = "string"
  description = "(Optional) Associate ACM certificate to and ALB listener."
  default     = ""
}

variable "domain_name" {
  type        = "string"
  description = "Domain name to associate with the ACM certificate."
}

variable "environment" {
  type        = "string"
  description = "Environment tag."
}

variable "zone_name" {
  type        = "string"
  description = "The Akamai Fast DNS zone name."
}
