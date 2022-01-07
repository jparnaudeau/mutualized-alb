

variable "environment" {
  type        = string
  default     = ""
  description = "Standard environment attribute"
}

variable "route53_environment" {
  type        = string
  description = "(optional) describe your variable"
  default     = null
}

variable "s3bucket_environment" {
  type        = string
  description = "(optional) describe your variable"
  default     = null
}
variable "product_name" {
  type        = string
  default     = ""
  description = "Standard product_name attribute"
}

variable "service_name" {
  type        = string
  default     = ""
  description = "Standard service_name attribute"
}

variable "short_description" {
  type        = string
  default     = ""
  description = "Standard short_description attribute"
}

variable "cluster_function" {
  type        = string
  default     = ""
  description = "Standard cluster_function attribute"
}

variable "app_sn" {
  type        = string
  default     = ""
  description = "Standard app_sn attribute"
}


variable "owner" {
  type        = string
  default     = ""
  description = "Standard owner attribute"
}


variable "costcenter" {
  type        = string
  default     = ""
  description = "Standard short_description attribute"
}


variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `environment`, `product_name`, `short_description` and `property`"
}

variable "property" {
  type        = list(string)
  default     = []
  description = "Additional property attributes (e.g. `public`, `cicd`, `snapshot`, `master`, `shared`, `standalone`)"
}

# variable "version" {
#   type        = string
#   default     = ""
#   description = "User provided numerical version or version label ie. "1.0" or "master" "v00" "
# }

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessLine','Prevoyance')`"
}

variable "additional_asg_tag" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map, fo ASG resources"
}

variable "naming_order" {
  type        = list(string)
  default     = []
  description = "The naming order of the namespace output used on every resources names"
}


variable "db_engine_shortname" {
  type = map(string)

  default = {
    "mysql"         = "m"
    "mariadb"       = "ma"
    "postgres"      = "p"
    "sqlserver-ee"  = "s"
    "sqlserver-se"  = "s"
    "sqlserver-web" = "s"
  }
}
