


variable "target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "name_prefix" {
  description = "(optional)"
  type        = string
  default     = null
}


variable "vpc_id" {
  type        = string
  description = "The VPC ID where generated ALB target group will be provisioned"
}

variable "tags" {
  type        = map(string)
  description = "A list of tags to apply to the ecr repo"
  default     = {}
}

variable "target_group_port" {
  type        = number
  default     = 80
  description = "The listen port on the target group destination"
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

variable "target_group_protocol" {
  type        = string
  default     = "HTTP"
  description = "The protocol for the created target group"
}

variable "alb_listener_arn" {
  description = "Listener to add the rule(s) to"
  type        = string
}

variable "target_type" {
  type        = string
  default     = "instance"
  description = "The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group"
}

variable "stickiness" {
  type = object({
    enabled  = bool
    duration = number
    type     = string
  })
  default = {
    type     = "lb_cookie"
    enabled  = false
    duration = 86400
  }
  description = "define the stickiness parameter such as duration and type : i.e type = lb_cookie , duration= 86400"
}

variable "health_check" {
  type        = map(string)
  default     = {}
  description = "The default target group's health check configuration, will be merged over the default (see locals.tf)"
}

variable "deregistration_delay" {
  type        = number
  default     = 300
  description = "The amount of time to wait in seconds before remonving the container from the target"
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

variable "listener_conditions" {
  type        = list(map(list(string)))
  default     = []
  description = "List of conditions for the rule to be applied"
}


variable "start_priority" {
  type        = number
  description = "priority applied to this rule"
  default     = 99
}


variable "alb_loadbalancer_arn" {
  type        = string
  description = "Arn of the ALB this resources apply to"
}