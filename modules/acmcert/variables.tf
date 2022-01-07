

variable "domains" {
  type = set(object({
    name              = string
    primary_domain    = string
    alternative_names = set(string)
    validation_method = string
    options = set(object({
      certificate_transparency_logging_preference = string
    }))
    listener = object({
      port    = number
      alb_arn = string
    })
  }))
  description = "The dns main domain and subject alternatives names to issue tls certificate"
}

variable "timeouts" {
  type = set(object({
    create = string
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "The common conventional tags"
}

variable "domain_zone_id" {
  type        = string
  description = "The route53 domain hosted zoneId"
}

variable "dns_ttl" {
  description = "The TTL of DNS recursive resolvers to cache information about this record."
  type        = number
  default     = 60
}
