# -- GLOBAL Locals -----------------------------------------------

locals {
  
  domain_name = var.domain_name

  # the list of services that we want expose with the ingress
  # the label is used in cfg map
  services_label = {
    "shipping" = {
      label = "shipping"
    },
    "commercial" = {
      label = "commercial"
    },
  }

  cfg = {
    defaults = {
      region = var.region

      # some variables contextualized with the service label
      services = {
        "shipping" = {
          service_label     = local.services_label["shipping"].label
          service_name      = format("%s-%s", var.application_short_name, local.services_label["shipping"].label)
          service_fqdn      = format("%s-%s.%s", var.application_short_name, local.services_label["shipping"].label, local.domain_name)
          target_group_port = 9090
          rule_priority     = 99
        },
        "commercial" = {
          service_label     = local.services_label["commercial"].label
          service_name      = format("%s-%s", var.application_short_name, local.services_label["commercial"].label)
          service_fqdn      = format("%s-%s.%s", var.application_short_name, local.services_label["commercial"].label, local.domain_name)
          target_group_port = 9091
          rule_priority     = 98
        },
      }

      # a default map used for generation certificate
      domains = {
          name              = format("alb-cma-stack.%s",local.domain_name)
          alternative_names = []
          validation_method = "DNS"
          options = [
            {
              certificate_transparency_logging_preference = "ENABLED"
            }
          ]
          listener = {
            port    = var.alb_listener_port
            alb_arn = data.terraform_remote_state.alb.outputs.alb_arn
          }
      },
    }
  }

  # the merge function is working only on the top level of the map. So, merging default values with overriden values
  # permit to not loose all the values that are not overriden !!
  # please fill the variable "overrides" to override some values
  stack = {
    services = merge(local.cfg["defaults"].services,lookup(var.overrides,"services",{}))
    domains  = merge(local.cfg["defaults"].domains,lookup(var.overrides,"domains",{}))
  }

  this  = merge(local.cfg["defaults"],{ services = local.stack["services"], domains = local.stack["domains"]})

  # despite our efforts, even with the shortname, there are some cases (for miscuat or miscprod by example) where the "targetgroup name" is > 32
  # so if > 32, we make a substring on 6 first characters of the service labels (other field can't be change otherwise is generated lot's of update)
  # some variables for target groups contextualized with the service label
  target_groups = {
    "shipping" = {
      tg_short_name = length(format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,local.this.services["shipping"].service_label,local.this.services["shipping"].target_group_port)) <= 32 ? format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,local.this.services["shipping"].service_label,local.this.services["shipping"].target_group_port) : format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,substr(local.this.services["shipping"].service_label,0,6),local.this.services["shipping"].target_group_port)
    },
    "commercial" = {
      tg_short_name = length(format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,local.this.services["commercial"].service_label,local.this.services["commercial"].target_group_port)) <= 32 ? format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,local.this.services["commercial"].service_label,local.this.services["commercial"].target_group_port) : format("tg-%s-%s-%s-%s",var.environment,var.application_short_name,substr(local.this.services["commercial"].service_label,0,6),local.this.services["commercial"].target_group_port)
    },
  }
}
