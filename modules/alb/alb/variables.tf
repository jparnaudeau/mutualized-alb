


variable "region" {
  description = "Region identifier."
  default     = "eu-central-1"
  type        = string
}


variable "tags" {
  description = "common tags."
  type        = map(string)
}


#-------------- ALB----------------#


variable "vpc_id" {
  type        = string
  description = "the vpc_id where this lb will be provision"
}



variable "namespace" {
  type        = string
  description = "for standard alb naming"
}



variable "custom_alb_name" {
  type        = string
  description = "custom alb name"
  default     = ""
}

variable "custom_alb_records" {
  type        = string
  description = "optional custom domain name"
  default     = ""
}

variable "is_alb_internal" {
  description = "If this variable is 'true' the ALB will be internal, therefore not exposed on the internet."
  type        = bool
  default     = true
}

variable "load_balancer_type" {
  description = "(optional)"
  type        = string
  default     = "application"
}

variable "enable_deletion_protection" {
  description = " If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to 'true'."
  type        = bool
  default     = true
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true."
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = " The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack."
  type        = string
  default     = "ipv4"
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60."
  type        = number
  default     = 60
}

# variable "access_logs" {
#   description = "An ALB access_logs block"
#   type        = map(string)
#   #default     = null
# }


variable "access_logs" {
  description = "nested object for defining access log"
  type = set(object(
    {
      bucket  = string
      enabled = bool
      prefix  = string
    }
  ))
  default = []
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether invalid header fields are dropped in application load balancers. Defaults to false."
  type        = bool
  default     = false
}


variable "subnet_ids" {
  description = "List of subnets"
  type        = list(string)
}

variable "subnet_mapping" {
  type = set(object({
    allocation_id        = string
    private_ipv4_address = string
    subnet_id            = string
  }))
  default     = []
  description = "nested mode: NestingSet"
}

variable "enable_alb_alias" {
  type        = bool
  description = "(optional) true or false to allow creation friendly alias record for alb"
  default     = true
}

variable "domain_zone" {
  description = "The domain hosted zone of this environment"
  type        = string
  default     = null
}

variable "is_private_zone" {
  description = "This variable indicate if route53 alias record for the alb is part of public or private hosted_zone domain"
  type        = bool
  default     = false
}

variable "timeouts" {
  type = set(object(
    {
      create = string
      delete = string
      update = string
    }
  ))
  default     = []
  description = "resource creation timeouts"
}

# -----------  WAF (These variables are mandatory if your ALB is external (internal = false))----------#

variable "waf_web_acl_id" {
  description = "WAF Web ACL ID required for an external ALB."
  type        = string
  default     = null
}

variable "security_groups" {
  type        = list(string)
  default     = []
  description = "List of security groups to attach to the ALB"
}

########################################################################################################################
#
# ROUTE53
#
####################################
/*
variable "shield_health_check_type" {
  description = "The protocol to use when performing health checks. Valid values are HTTP, HTTPS"
  type        = string
  default     = "HTTPS"
}

variable "shield_health_check_port" {
  description = "The port of the endpoint to be checked."
  type        = number
  default     = 443
}

variable "shield_health_check_path" {
  description = "The path that you want Amazon Route 53 to request when performing health checks."
  type        = string
  default     = ""
}

variable "shield_health_check_failure_threshold" {
  description = "The number of consecutive health checks that an endpoint must pass or fail."
  type        = string
  default     = "3"
}

variable "shield_health_check_interval" {
  description = "The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request."
  type        = string
  default     = "30"
}

variable "shield_health_check_measure_latency" {
  description = "A Boolean value that indicates whether you want Route 53 to measure the latency between health checkers in multiple AWS regions and your endpoint and to display CloudWatch latency graphs in the Route 53 console."
  type        = bool
  default     = true
}
*/
