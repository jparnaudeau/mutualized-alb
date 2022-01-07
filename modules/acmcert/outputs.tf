

output "acm_certificate_arn" {
  value       = try(aws_acm_certificate.this, null)
  description = "The certificate arn"
}


output "records_validation" {
  value = aws_route53_record.dnsrecord_validation
}


output "certificate_validation" {
  value = aws_acm_certificate_validation.acm_validation
}

# output "certificate_domain_name" {
#   value       = try(aws_acm_certificate.this[*].domain_name, null)
#   description = "The certificate main domain_name"
# }


/*
output "data_listener" {
  value = { for key, listener in data.aws_lb_listener.selected : key => {
    arn               = listener.arn
    port              = listener.port
    protocol          = listener.protocol
    load_balancer_arn = listener.load_balancer_arn

  } }
}
*/

output "listener_certificate" {
  value = aws_lb_listener_certificate.listeners-cert
}


# output "listeners_arns" {
#   value = try(aws_lb_listener_certificate.listeners-cert[*], null)
# }