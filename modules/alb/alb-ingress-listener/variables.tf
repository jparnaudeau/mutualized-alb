
variable "namespace" {
  type        = string
  description = "for standard alb naming"
}

variable "alb_loadbalancer_arn" {
  type        = string
  description = "Arn of the ALB this resources apply to"
}

variable "alb_security_group_id" {
  type        = string
  description = "The alb security group to be applied to security_group_rules in this modules"
}


variable "http_listener_ports" {
  description = "A list of ports to listen on for HTTP requests."
  type        = set(string)
  default     = []
}

variable "redirect" {
  type = object({
    enabled     = bool
    port        = string
    protocol    = string
    status_code = string
  })
  description = "(optional) control activation of ingress redirect traffic to https"
  default = {
    enabled     = false
    port        = "443"
    protocol    = "HTTPS"
    status_code = "HTTP_301"
  }
}

variable "https_ssl_policy" {
  type        = string
  description = "The name of the SSL Policy for the listener"
  default     = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
}

variable "https_listener_ports_and_certs" {
  description = "A list of objects that define the ports to listen on for HTTPS requests. Each object should have the keys 'port' (the port number to listen on) and 'certificate_arn' (the ARN of an ACM or IAM TLS cert to use on this listener)."
  type = set(object({
    port     = number
    cert_arn = string
  }))
  default = []
}

variable "allow_inbound_from_cidr_blocks" {
  description = "A list of IP addresses in CIDR notation from which the load balancer will allow incoming HTTP/HTTPS requests."
  type = set(object({
    label       = string
    cidrs       = list(string)
    description = string
  }))
  default = []
}

variable "allow_inbound_from_security_groups" {
  description = "A list of Security Group IDs from which the load balancer will allow incoming HTTP/HTTPS requests. Any time you change this value, make sure to update var.allow_inbound_from_security_groups too!"
  type = set(object({
    label       = string
    secgroup    = string
    description = string
  }))
  default = []
}

variable "fixed_response" {
  type = object({
    content_type = string
    message_body = string
    status_code  = string
  })
  default = {
    content_type = "text/plain"
    message_body = "404: Nothing to see here. This is unfortunate"
    status_code  = 404
  }
  description = "define the fixed_response parameter such as content_type, message_body and status_code"
}