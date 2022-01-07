
resource "aws_lb_target_group" "ingress_target_service" {
  name                               = var.target_group_name
  port                               = var.target_group_port
  protocol                           = var.target_group_protocol
  proxy_protocol_v2                  = var.proxy_protocol_v2
  slow_start                         = var.slow_start
  vpc_id                             = var.vpc_id
  target_type                        = var.target_type
  deregistration_delay               = var.deregistration_delay
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type
  lambda_multi_value_headers_enabled = var.lambda_multi_value_headers_enabled

  dynamic "stickiness" {
    for_each = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = stickiness.value.type
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
    }
  }

  dynamic "health_check" {
    for_each = [local.health_check_settings]
    content {
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
      interval            = lookup(health_check.value, "interval", null)
      matcher             = lookup(health_check.value, "matcher", null)
    }
  }

  tags = merge({ "Name" = var.target_group_name }, var.tags)

  lifecycle {
    create_before_destroy = true
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# These rules determine which requests get routed to the Target Group  via 
#  - host_based routing 
#  - path_based routing 
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_listener_rule" "routing" {
  count = length(var.listener_conditions)

  listener_arn = var.alb_listener_arn
  priority     = var.start_priority + count.index

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ingress_target_service.arn
  }

  dynamic "condition" {
    for_each = try(var.listener_conditions[*], [])
    content {

      dynamic "host_header" {
        for_each = lookup(condition.value, "host_header", [])
        content {
          values = lookup(condition.value, "host_header", null)
        }
      }
      dynamic "path_pattern" {
        for_each = lookup(condition.value, "path_pattern", [])
        content {
          values = lookup(condition.value, "path_pattern", null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [priority]
  }
}
