output "services" {
    value = { for k,v in local.services_label : k => {
        dns_alias        = local.this.services[k].service_fqdn,
        target_group_arn = module.ingress_target[k].target_group_arn,
        url              = format("https://%s%s",local.this.services[k].service_fqdn,var.alb_listener_port == 443 ? "" : format(":%s",var.alb_listener_port))
    }} 
}



output "final_cfg" {
    description = "The final map used by terraform to configure all ingress elements"
    value = local.this
}

