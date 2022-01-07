
output "namespace" {
  value       = local.namespace
  description = "Standard namespace label"
}

output "label" {
  value = {
    name              = local.namespace # <------ ${environment}-{product_name}-${short_description}
    stage             = local.cfg[var.environment].stage
    environment       = local.environment
    product_name      = local.product_name
    short_description = local.short_description
    property          = local.property
    costcenter        = local.costcenter
    owner             = local.owner
    tags = {
      common_tags  = local.common_tags
      tags_for_asg = local.tags_for_asg
    }
    namespace_ssm_parameter = local.namespace_ssm_parameter
    route53_environment     = local.cfg[var.environment].route53_environment
    s3bucket_environment    = local.cfg[var.environment].s3bucket_environment
  }
  description = "Standard namespaces label containing all the common standard attributes "
}

output "stage" {
  value = local.cfg[var.environment].stage
}

output "route53_environment" {
  value       = local.cfg[var.environment].route53_environment
  description = "Route53 environment (dev02)"
}

output "s3bucket_environment" {
  value       = local.cfg[var.environment].s3bucket_environment
  description = "S3 bucket environment (dev02)"
}

output "tags" {
  value       = local.common_tags
  description = "Standard Tag map"
}

output "tags_for_asg" {
  value       = local.tags_for_asg
  description = "Additional standard tags as a list of maps for autoscaling groups"
}

output "property" {
  value       = local.property
  description = "Standard list of properties"
}


output "environment" {
  value       = local.environment
  description = "Standard environment label"
}


output "product_name" {
  value       = local.product_name
  description = "Standard product_name label"
}


output "short_description" {
  value       = local.short_description
  description = "Standard short_description label"
}

output "costcenter" {
  value       = local.costcenter
  description = "Standard costcenter label"
}

output "owner" {
  value       = local.owner
  description = "Standard owner label"
}

output "service_name" {
  value       = var.service_name
  description = "the non standard service name suffix"
}

output "application" {
  value       = local.application
  description = "Standard application label"
}


#--------------- ecs output value-------------#

output "ecs_cluster_name" {
  value       = local.ecs_cluster_name
  description = "the ecs standard cluster name"
}

output "ecs_service_name" {
  value       = local.ecs_service_name
  description = "the ecs standard service name"
}

output "ecs_task_name" {
  value       = local.ecs_task_name
  description = "the ecs standard service name"
}

#------ alb ---------#

output "alb_name" {
  value       = local.alb_name
  description = "the ecs standard service name"
}

#--------------- parameter store path --------#

output "namespace_ssm_parameter" {
  value       = local.namespace_ssm_parameter
  description = "Standard namespace label for SSM parameter store PATH Key indentifier "
}

#------------------ route53 ----------#
output "shield_route53_healthcheck_reference_name" {
  value       = local.shield_route53_healthcheck_reference_name
  description = "Reference name for Route53 health check (mandatory for all public resources)"
}

output "shield_route53_healthcheck_name" {
  value       = local.shield_route53_healthcheck_name
  description = "Name for Route53 health check (mandatory for all public resources)"
}



#  A map of standard common name for use in `ecs ec2 cluster module for example`. with `s` at namespaces 
# it's different from namespace without `s` which equal to string: ${environment}-${product_name}-${short_description} 
output "namespaces" {
  value = {
    name              = local.namespace
    environment       = local.environment
    product_name      = local.product_name
    short_description = local.short_description
    costcenter        = local.costcenter
    owner             = local.owner
  }
  description = "Standard namespaces label containing all the common standard attributes "
}
