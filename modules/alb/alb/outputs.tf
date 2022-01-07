

output "load_balancer_id" {
  value       = aws_alb.main.id
  description = "The ARN of the load balancer."
}

output "load_balancer_arn" {
  value       = aws_alb.main.arn
  description = "The ARN of the load balancer"
}

output "load_balancer_arn_suffix" {
  value       = aws_alb.main.arn_suffix
  description = "The ARN suffix for use with CloudWatch Metrics."
}

output "load_balancer_dns_name" {
  value       = aws_alb.main.dns_name
  description = "The amazon DNS name of the load balancer."
}

output "load_balancer_zone_id" {
  value       = aws_alb.main.zone_id
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "alb_alias_name" {
  value       = try(aws_route53_record.alb_alias[0].name, null)
  description = "The route53 record alias name of the load balancer."
}

output "alb_alias_fqdn" {
  value       = try(aws_route53_record.alb_alias[0].fqdn, null)
  description = "The route53 record alias FQDN of the load balancer."
}

output "alb_alias_zone_id" {
  value       = try(aws_route53_record.alb_alias[0].zone_id, null)
  description = "The route53 record alias zoneId of the load balancer."
}
