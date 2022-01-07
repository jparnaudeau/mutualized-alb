


output "target_group_arn" {
  description = "The target group ARN"
  value       = aws_lb_target_group.ingress_target_service.arn
}