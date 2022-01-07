

resource "aws_alb" "main" {
  name                             = var.custom_alb_name == "" ? format("alb-%s", var.namespace) : var.custom_alb_name
  internal                         = var.is_alb_internal
  load_balancer_type               = var.load_balancer_type
  enable_deletion_protection       = var.enable_deletion_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  idle_timeout                     = var.idle_timeout
  subnets                          = var.subnet_ids
  security_groups                  = var.security_groups
  drop_invalid_header_fields       = var.drop_invalid_header_fields

  dynamic "access_logs" {
    for_each = var.access_logs
    content {
      bucket  = access_logs.value["bucket"]
      enabled = access_logs.value["enabled"]
      prefix  = access_logs.value["prefix"]
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      allocation_id        = subnet_mapping.value["allocation_id"]
      private_ipv4_address = subnet_mapping.value["private_ipv4_address"]
      subnet_id            = subnet_mapping.value["subnet_id"]
    }
  }

  tags = merge(
    {
      "Description" = "Application Load Balancer of ${element(split("-", var.namespace), 1)} project"
      "Name"        = format("alb-%s", var.namespace)
    },
    var.tags,
  )
}

#------ we should attach a waf to alb if it's public alb  ------#
/*
resource "aws_wafregional_web_acl_association" "main" {
  count        = var.is_alb_internal ? 0 : 1
  resource_arn = aws_alb.main.arn
  web_acl_id   = var.waf_web_acl_id
}
*/
