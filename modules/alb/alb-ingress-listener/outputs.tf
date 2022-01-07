

output "https_listener_arn" {
  description = "The ARN of the HTTPS listener"
  value       = [ for v in toset(var.https_listener_ports_and_certs) : aws_lb_listener.https_secure_ingress[*][format("https-%s", v.port)].arn]
}

output "https_listener_arn_map" {
  description = "The map ARN of the HTTPS listener, the key of the map is the port of your listener"
  value       = { for v in toset(var.https_listener_ports_and_certs) : tostring(v.port) => aws_lb_listener.https_secure_ingress[*][format("https-%s", v.port)].arn }
}

