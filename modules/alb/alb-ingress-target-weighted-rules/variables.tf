

variable "vpc_id" {
  type        = string
  description = "The VPC ID where generated ALB target group will be provisioned"
}

variable "tags" {
  type        = map(string)
  description = "A list of tags to apply to the ecr repo"
  default     = {}
}

variable "ingress_target" {
  type = set(object({
    variant      = string
    health_check = map(string)
    name         = string
    target_port  = number
    target_type  = string
    protocol     = string
  }))
  description = "(optional) target group parameter"
}

variable "listener_arn" {
  description = "Listener to add the rule(s) to"
  type        = string
}

variable "action" {
  description = "dynamic action applied to blue/green target_group traffic registered with a listener"
  type = set(object({
    type = string
    forward = list(object({
      target_group = map(object({
        weight = number
      }))
      stickiness = list(object({
        duration = number
        enabled  = bool
      }))
    }))
  }))
  default = [{
    type    = "forward"
    forward = []
  }]
}

variable "listener_conditions" {
  type        = set(map(list(map(set(string)))))
  default     = []
  description = "List of conditions for the rule to be applied"
}


variable "stickiness" {
  type = object({
    enabled  = bool
    duration = number
    type     = string
  })
  default = {
    type     = "lb_cookie"
    enabled  = true
    duration = 60
  }
  description = "define the stickiness parameter such as duration and type : i.e type = lb_cookie , duration= 86400"
}

variable "deregistration_delay" {
  type        = number
  default     = 300
  description = "The amount of time to wait in seconds before remonving the container from the target"
}

variable "proxy_protocol_v2" {
  description = "(optional)"
  type        = bool
  default     = null
}

variable "slow_start" {
  description = "(optional)"
  type        = number
  default     = null
}

variable "priority" {
  type        = number
  description = "priority applied to this rule"
  default     = null
}

variable "lambda_multi_value_headers_enabled" {
  description = "(optional)"
  type        = bool
  default     = null
}

variable "load_balancing_algorithm_type" {
  description = "(optional)"
  type        = string
  default     = null
}