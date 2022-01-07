

# ------------------------------------------------------------------------------------------------#
# These listeners determine from which port ingress traffic enter into the alb ingress route      #
# ------------------------------------------------------------------------------------------------#


#------- http listener, http redirect listener and https listener --------#


resource "aws_lb_listener" "http_unsecure_ingress" {
  for_each = local.enable_http_listener ? {
  for item in toset(var.http_listener_ports) : format("http-%s", item) => item } : {}

  load_balancer_arn = var.alb_loadbalancer_arn
  port              = each.value
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    dynamic "fixed_response" {
      for_each = var.fixed_response == null ? [] : [var.fixed_response]
      content {
        content_type = var.fixed_response.content_type
        message_body = var.fixed_response.message_body
        status_code  = var.fixed_response.status_code
      }
    }
  }
}


resource "aws_lb_listener" "http_redirect_ingress" {
  for_each = local.enable_redirect_to_https ? {
  for item in toset(var.http_listener_ports) : format("http-%s-redirect-%s", item, var.redirect.port) => item } : {}

  load_balancer_arn = var.alb_loadbalancer_arn
  port              = each.value
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = var.redirect.port
      protocol    = var.redirect.protocol
      status_code = var.redirect.status_code
    }
  }
}


resource "aws_lb_listener" "https_secure_ingress" {
  for_each = local.enable_https_listener ? {
  for item in toset(var.https_listener_ports_and_certs) : format("https-%s", item.port) => item } : {}

  port              = each.value["port"]
  certificate_arn   = each.value["cert_arn"]
  load_balancer_arn = var.alb_loadbalancer_arn
  protocol          = "HTTPS"
  ssl_policy        = var.https_ssl_policy

  default_action {
    type = "fixed-response"

    dynamic "fixed_response" {
      for_each = var.fixed_response == null ? [] : [var.fixed_response]

      content {
        content_type = var.fixed_response.content_type
        message_body = var.fixed_response.message_body
        status_code  = var.fixed_response.status_code
      }
    }
  }
}


resource "aws_security_group_rule" "allow_http_inbound_from_cidr_blocks" {
  for_each = { for pair in local.http_ingress_cidr_blocks : format("%s-%s", pair[1].label, pair[0]) => {
    port        = pair[0]
    cidr_blocks = pair[1].cidrs
    description = coalesce(lookup(pair[1], "description", null), element(split("-", var.namespace), 1))
    }
  }

  description       = format("Alb-listener inbound access for %s", each.value.description)
  type              = "ingress"
  from_port         = tonumber(each.value.port)
  to_port           = tonumber(each.value.port)
  protocol          = "tcp"
  security_group_id = var.alb_security_group_id
  cidr_blocks       = each.value.cidr_blocks
}


resource "aws_security_group_rule" "allow_http_inbound_from_security_groups" {
  for_each = { for pair in local.http_ingress_security_groups : format("%s-%s", pair[1].label, pair[0]) => {
    port           = pair[0]
    security_group = pair[1].secgroup
    description    = coalesce(lookup(pair[1], "description", null), element(split("-", var.namespace), 1))
    }
  }

  description              = format("Alb-listener inbound access for %s", each.value.description)
  type                     = "ingress"
  from_port                = tonumber(each.value.port)
  to_port                  = tonumber(each.value.port)
  protocol                 = "tcp"
  security_group_id        = var.alb_security_group_id
  source_security_group_id = each.value.security_group
}


resource "aws_security_group_rule" "allow_https_inbound_from_cidr_blocks" {
  for_each = {
    for tuple in local.https_ingress_cidr_blocks : format("%s-%s", tuple.label, tuple.port) => {
      port        = tuple.port
      cidr_blocks = tuple.cidr_blocks
      description = tuple.description
    }
  }

  description       = format("Alb-listener allow inbound access from cidr for %s", each.value.description)
  type              = "ingress"
  from_port         = tonumber(each.value["port"])
  to_port           = tonumber(each.value["port"])
  protocol          = "tcp"
  security_group_id = var.alb_security_group_id
  cidr_blocks       = each.value.cidr_blocks
}


resource "aws_security_group_rule" "allow_https_inbound_from_security_groups" {
  for_each = {
    for tuple in local.https_ingress_security_groups : format("%s-%s", tuple.label, tuple.port) => {
      port           = tuple.port
      security_group = tuple.secgroup
      description    = tuple.description
    }
  }

  description              = format("Alb-listener allow inbound access from secgroup for %s", each.value.description)
  type                     = "ingress"
  from_port                = tonumber(each.value["port"])
  to_port                  = tonumber(each.value["port"])
  protocol                 = "tcp"
  security_group_id        = var.alb_security_group_id
  source_security_group_id = each.value.security_group
}




locals {

  enable_https_listener    = signum(length(var.https_listener_ports_and_certs)) > 0
  enable_http_listener     = alltrue([signum(length(var.http_listener_ports)) > 0, !(signum(length(var.https_listener_ports_and_certs)) > 0 && var.redirect.enabled)])
  enable_redirect_to_https = alltrue([signum(length(var.http_listener_ports)) > 0, (signum(length(var.https_listener_ports_and_certs)) > 0 && var.redirect.enabled)])

  enable_http_inbound_cidr_blocks     = alltrue([signum(length(var.allow_inbound_from_cidr_blocks)) > 0, local.enable_http_listener])
  enable_http_inbound_security_groups = alltrue([signum(length(var.allow_inbound_from_security_groups)) > 0, local.enable_http_listener])

  enable_https_inbound_cidr_blocks     = alltrue([signum(length(var.allow_inbound_from_cidr_blocks)) > 0, local.enable_https_listener])
  enable_https_inbound_security_groups = alltrue([signum(length(var.allow_inbound_from_security_groups)) > 0, local.enable_https_listener])


  # setproduct : produit cartesien between port & security_group for http ingress . to get a collection of element that will be used for loop iteration and producing a specific 
  # security_group_rule for each element. each element will be a pair of (port/security_group) 
  http_ingress_security_groups = local.enable_http_inbound_security_groups ? setproduct(toset(var.http_listener_ports), toset(var.allow_inbound_from_security_groups)) : []

  # setproduct : produit cartesien between port & cidr_blocks ingress. each element of this collection will be a pair of port/cidr_blocks.
  http_ingress_cidr_blocks = local.enable_http_inbound_cidr_blocks ? setproduct(toset(var.http_listener_ports), toset(var.allow_inbound_from_cidr_blocks)) : []

  # setproduct : produit cartesien between port & cidr_blocks https ingress
  https_ingress_cidr_blocks = local.enable_https_inbound_cidr_blocks ? [
    for pair in setproduct(toset(var.https_listener_ports_and_certs), toset(var.allow_inbound_from_cidr_blocks)) :
    merge(pair[0], { cidr_blocks = pair[1].cidrs, label = pair[1].label,
    description = coalesce(lookup(pair[1], "description", null), element(split("-", var.namespace), 1)) })
  ] : []

  #setproduct : produit cartesien between port & security_group for https ingress
  https_ingress_security_groups = local.enable_https_inbound_security_groups ? [
    for pair in setproduct(toset(var.https_listener_ports_and_certs), toset(var.allow_inbound_from_security_groups)) :
    merge(pair[0], { secgroup = pair[1].secgroup, label = pair[1].label,
    description = coalesce(lookup(pair[1], "description", null), element(split("-", var.namespace), 1)) })
  ] : []

}

