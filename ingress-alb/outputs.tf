output "https_listener_arn" {
    description = "The ARN of the HTTPS listener"
    value       = module.ingress_listener.https_listener_arn
}

output "https_listener_arn_map" {
    description = "The map ARN of the HTTPS listener, the key of the map is the port of your listener"
    value       = module.ingress_listener.https_listener_arn_map
}

output "alb_arn" {
  value       = module.alb.load_balancer_arn
  description = "application loadbalancer arn"
}


output "alb_dns_name" {
  value       = module.alb.load_balancer_dns_name
  description = "alb dns name"
}


output "load_balancer_zone_id" {
  value       = module.alb.load_balancer_zone_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

/*
output "alb_security_group_id" {
  value       = module.alb.alb_security_group_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}


output "alb_acm_certificate_arn" {
  value = aws_acm_certificate.alb_acm_certificate.arn
  description = "The ARN of the ACM Certificate associate to the ALB"
}
*/

output "alb_alias_fqdn" {
  value       = module.alb.alb_alias_fqdn
  description = "The route53 record alias FQDN of the load balancer."
}

output "alb_alias_zone_id" {
  value       = module.alb.alb_alias_zone_id
  description = "The route53 record alias zoneId of the load balancer."
}
