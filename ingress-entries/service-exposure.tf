#########################
# Create the Target group on the listener
# and pointing on the service
##########################
module "ingress_target" {
  source               = "../modules/alb/alb-ingress-target-rules"
  for_each = local.services_label

  alb_loadbalancer_arn = data.terraform_remote_state.alb.outputs.alb_arn
  target_group_name    = local.target_groups[each.key].tg_short_name
  target_group_port    = local.this.services[each.key].target_group_port
  target_type          = var.target_type
  alb_listener_arn     = join(",",lookup(data.terraform_remote_state.alb.outputs.https_listener_arn_map,var.alb_listener_port))
  vpc_id               = data.aws_vpc.default.id
  health_check         = var.health_check
  tags                 = module.naming.tags
  start_priority       = local.this.services[each.key].rule_priority
  listener_conditions = [
    {
      host_header = [local.this.services[each.key].service_fqdn]
    },
  ]
}

#########################
# Create the R53 Record type A
# for our service
##########################
resource "aws_route53_record" "service_dns" {
  for_each = local.services_label

  zone_id = data.aws_route53_zone.this.id
  name    = local.this.services[each.key].service_name      # need to correspond to the locals.xxx.domains.primary_domain
  type    = "A"
  alias {
    name                   = data.terraform_remote_state.alb.outputs.alb_alias_fqdn
    zone_id                = data.aws_route53_zone.this.id
    evaluate_target_health = true
  }
}


# #########################
# # Generate a certificate for our service
# # and associate it to the ALB Listener
# ##########################
module "cert_tls_shipping" {
  source         = "../modules/acmcert"
  for_each = local.services_label

  tags             = module.naming.tags
  domain_zone_id   = data.aws_route53_zone.this.id
  domains          = [merge(local.this.domains,{primary_domain = local.this.services[each.key].service_fqdn })]
}
