#--------- common standard attributes ---------------#
variable "region" {
  description = "region"
  default     = "eu-west-3"
  type        = string
}

variable "environment" {
  description = "Envrionment name. Ie: dev, sandbox, ..."
  type        = string
}

variable "application_short_name" {
  description = "Application Short name (used in alb name)"
  type        = string
}

variable "short_description" {
  description = "The short description"
  default     = "stack"
  type        = string
}

variable "costcenter" {
  description = "CostCenter"
  type        = string
}

variable "owner" {
  description = "Email of the team owning application"
  type        = string
}

variable "product_name" {
  description = "Application"
  type        = string
}

/*


variable "route53_environment" {
  description = "Envrionment name. Ie: dev, sandbox, ..."
  type        = string
}
*/

#-------------- domain acm cert --------------#

variable "domain_name" {
  description = "The R53 domain name"
}
/*
variable "domains" {
  type = object({
    primary_domain     = string
    alternatives_names = list(string)
  })
}


variable "cert_validation_method" {
  description = "The method used to validate the certificate"
  default     = "DNS"
}
*/
#-------------- alb attributes --------------#
variable "allow_inbound_from_cidr_blocks" {
  description = "A list of IP addresses in CIDR notation from which the load balancer will allow incoming HTTP/HTTPS requests."
  type        = list(string)
  default     = []
}

variable "custom_alb_name" {
  description = "Keep possibility to override alb namespace"
  type        = string
  default     = ""
}

/*
variable "enable_replication_dr" {
  type        = bool
  description = "Enable /Disable the replication of the logs bucket in DR Region"
  default     = true
}
*/



variable "listener_port" {
  description = "The port on which the listener is created. By default, 443"
  type        = number
  default     = 443
}
