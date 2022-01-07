# ===========================================================
# Common Attributes
# ===========================================================
variable "region" {
  description = "region"
  default     = "eu-west-3"
  type        = string
}

variable "environment" {
  description = "Envrionment name. Ie: dev, sandbox, ..."
  type        = string
}

variable "product_name" {
  description = "Application Short Name"
  type        = string
}

variable "application_short_name" {
  description = "Application Short name (used in alb name)"
  type        = string
  default     = ""
}

variable "short_description" {
  description = "The short description"
  default     = "main"
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


# ===========================================================
# ALB Attributes
# ===========================================================


variable "alb_listener_port" {
  type          = number
  description   = "The port of the LoadBalancer Listener. By default 443"
  default       = 443
}

variable "domain_name" {
  type        = string
  description = "The R53 domain name"
}

# ===========================================================
# TargetGroup Attributes
# ===========================================================
variable "health_check" {
  type        = map(string)
  description = "The default target group's health check configuration, will be merged over the default (see locals.tf)"
  default     = {
    path         = "/"
    port         = "traffic-port"
    protocol     = "HTTP"
    matcher      = "200-399"
  }
}

variable "target_type" {
  type        = string
  description = "The type of target  instance or ip"
  default     = "ip"
}

# ===========================================================
# Overriden Attributes
# ===========================================================
variable "overrides" {
  type = any
  description = "a map containing values to override"
  default = {}
}
