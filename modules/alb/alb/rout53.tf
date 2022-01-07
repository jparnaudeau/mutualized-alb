###################################################
#
# ROUTE53 CONFIGURATION
#
###################################################

locals {
  customize_name = split("-", var.namespace)
}

data "aws_route53_zone" "selected" {
  count        = var.enable_alb_alias ? 1 : 0
  name         = trimsuffix(var.domain_zone, ".")
  private_zone = var.is_private_zone
}

resource "aws_route53_record" "alb_alias" {
  count   = var.enable_alb_alias ? 1 : 0
  name    = format("alb-%s", join("-", slice(local.customize_name, 1, length(local.customize_name))))
  zone_id = data.aws_route53_zone.selected[count.index].zone_id
  type    = "A"

  alias {
    name                   = aws_alb.main.dns_name
    zone_id                = aws_alb.main.zone_id
    evaluate_target_health = false
  }
}

##################################
# route53 health check
##################################
/*
resource "aws_route53_health_check" "shield" {
  count      = var.is_alb_internal ? 0 : 1
  depends_on = [aws_route53_record.alb_alias]

  reference_name    = var.shield_route53_healthcheck_reference_name
  type              = var.shield_health_check_type
  fqdn              = aws_route53_record.alb_alias[count.index].fqdn
  port              = var.shield_health_check_port
  resource_path     = var.shield_health_check_path
  failure_threshold = var.shield_health_check_failure_threshold
  request_interval  = var.shield_health_check_interval
  measure_latency   = var.shield_health_check_measure_latency

  tags = merge(
    var.tags,
    {
      Name                    = var.shield_route53_healthcheck_name
      Associated_Resource_ARN = aws_alb.main.arn
      Associated_Resource_ID  = aws_alb.main.id
    }
  )
}
*/