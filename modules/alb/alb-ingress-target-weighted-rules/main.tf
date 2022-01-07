
resource "aws_lb_target_group" "ingress_target" {
  for_each = { for tuple in var.ingress_target : tuple.variant => tuple }

  vpc_id                             = var.vpc_id
  name                               = each.value.name
  port                               = each.value.target_port
  protocol                           = each.value.protocol
  target_type                        = each.value.target_type
  proxy_protocol_v2                  = var.proxy_protocol_v2
  slow_start                         = var.slow_start
  deregistration_delay               = var.deregistration_delay
  lambda_multi_value_headers_enabled = var.lambda_multi_value_headers_enabled
  load_balancing_algorithm_type      = var.load_balancing_algorithm_type

  dynamic "stickiness" {
    for_each = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = stickiness.value.type
      enabled         = lookup(stickiness.value, "enabled", null)
      cookie_duration = lookup(stickiness.value, "cookie_duration", null)
    }
  }


  dynamic "health_check" {
    for_each = [merge(local.default_healthcheck, each.value.health_check)]
    #for_each = [local.health_check_settings]
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

  tags = merge({ Name = each.value.name }, var.tags)
}


# ---------------------------------------------------------------------------------------------------------------------
# These rules determine which requests get routed to the Target Group  via 
#  - host_based routing 
# or
#  - path_based routing 
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_listener_rule" "ingress_routing" {
  count = var.listener_conditions == (length(var.listener_conditions) == 0 || var.listener_conditions == null) ? 0 : length(var.listener_conditions)
  #for_each   = [ for lc in var.listener_conditions: lc if (length(lc) > 0 || lc != null) ]
  depends_on = [aws_lb_target_group.ingress_target]

  listener_arn = var.listener_arn
  priority     = var.priority

  dynamic "action" {
    for_each = var.action
    content {
      type = action.value["type"]

      dynamic "forward" {
        for_each = try(action.value.forward, null)
        content {

          dynamic "target_group" {
            iterator = target
            for_each = keys(forward.value.target_group)
            content {
              arn    = aws_lb_target_group.ingress_target[target.value].arn
              weight = forward.value.target_group[target.value].weight
            }
          }

          dynamic "stickiness" {
            for_each = lookup(forward.value, "stickiness", null)
            content {
              duration = try(stickiness.value["duration"], 120)
              enabled  = try(stickiness.value["enabled"], true)
            }
          }
        }
      }
    }
  }

  dynamic "condition" {
    for_each = try(var.listener_conditions, [])
    content {

      dynamic "host_header" {
        for_each = lookup(condition.value, "host_header", [])
        content {
          values = try(host_header.value["values"], null)
        }
      }
      dynamic "path_pattern" {
        for_each = lookup(condition.value, "path_pattern", [])
        content {
          values = try(path_pattern.value["values"], null)
        }
      }
      dynamic "source_ip" {
        for_each = lookup(condition.value, "source_ip", [])
        content {
          values = try(source_ip.value["values"], null)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [priority]
  }
}
