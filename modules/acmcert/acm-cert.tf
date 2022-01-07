


resource "aws_acm_certificate" "this" {
  for_each                  = { for item in var.domains : item.name => item }
  domain_name               = each.value.primary_domain
  subject_alternative_names = [for domain in each.value.alternative_names : domain if domain != each.value.primary_domain]
  validation_method         = each.value.validation_method

  dynamic "options" {
    for_each = each.value.options
    content {
      certificate_transparency_logging_preference = options.value.certificate_transparency_logging_preference
    }
  }

  lifecycle { create_before_destroy = true }

  tags = merge(
    { "Name" = format("tls-%s-certificate", each.value.name) },
    var.tags,
  { "Description" = format("certificate for %s internal alb", each.value.name) })
}



locals {
  domains_options = [for acm in values(aws_acm_certificate.this)[*] : acm.domain_validation_options]
}


resource "aws_route53_record" "dnsrecord_validation" {
  for_each = { for opts in flatten(local.domains_options) : opts.domain_name => {

    name   = opts.resource_record_name
    record = opts.resource_record_value
    type   = opts.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = var.dns_ttl
  zone_id         = var.domain_zone_id

  depends_on = [aws_acm_certificate.this]
}


resource "aws_acm_certificate_validation" "acm_validation" {
  for_each = { for acm in values(aws_acm_certificate.this)[*] : acm.domain_name => acm }

  certificate_arn         = each.value.arn
  validation_record_fqdns = [for record in aws_route53_record.dnsrecord_validation : record.fqdn]

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
    }
  }
}







# resource "aws_route53_record" "dnsrecord_validation" {
#   for_each = { for valid_options in(aws_acm_certificate.this.domain_validation_options) : valid_options.domain_name => {
#     name   = valid_options.resource_record_name
#     record = valid_options.resource_record_value
#     type   = valid_options.resource_record_type
#     }
#   }
#   allow_overwrite = true
#   name            = each.value.name
#   type            = each.value.type
#   records         = [each.value.record]
#   ttl             = var.domains["dns_ttl"]
#   zone_id         = var.domain_zone_id

#   depends_on = [aws_acm_certificate.this]
# }