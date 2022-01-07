
locals {

  defaults = {
    naming_order = ["environment", "product_name", "short_description", "property"]
    delimiter    = "-"
    property     = [""]
  }

  environment       = lower(var.environment)
  product_name      = lower(coalesce(var.product_name, var.app_sn))
  service_name      = lower(var.service_name)
  short_description = lower(coalesce(var.short_description, var.cluster_function))
  costcenter        = lower(var.costcenter)
  owner             = lower(var.owner)
  application       = lower(var.product_name)
  naming_order      = length(var.naming_order) > 0 ? var.naming_order : local.defaults.naming_order
  delimiter         = coalesce(var.delimiter, local.defaults.delimiter)
  ssm_delimiter     = "/"
  property          = compact(distinct(concat(var.property, local.defaults.property)))


  # ------ environement & stage normalization -------#
  cfg = {
    (var.environment) = {
      stage                = try(local.env_map[var.environment], local.env_map["default"]) # --> aws_account dev int uat prod. because somtimes aws_account != environment (e.g: `uatm` )
      route53_environment  = try(var.route53_environment, null)
      s3bucket_environment = try(var.s3bucket_environment, null)
    }
  }

  env_map = {
    uatm    = "uat"
    uatr    = "uat"
    intr    = "int"
    intm    = "int"
    ditr    = "int"
    ditm    = "int"
    devt    = "dev" # --> devt = "dev test" . Might be usefull for executing automated testing create and destroy with terratest or other testing framework
    devm    = "dev"
    devr    = "dev"
    default = var.environment
  }

  #---- tagging resources convention -----#

  # 1/
  selected_tags = {
    stage       = local.cfg[var.environment].stage
    environment = local.environment
    costCenter  = local.costcenter
    owner       = local.owner
    application = local.application
    property    = local.namespace_context.property
  }

  # 2/
  tags_generated = { for t in keys(local.selected_tags) : title(t) => local.selected_tags[t] if length(local.selected_tags[t]) > 0 }

  # 3/
  common_tags = merge(
    local.tags_generated,
    var.tags
  )

  # 4/ asg
  tags_for_asg = flatten([
    for key in keys(local.common_tags) : merge(
      {
        key   = key
        value = local.common_tags[key]
      },
      var.additional_asg_tag
    )
  ])


  #---- naming resources convention -----#

  namespace_context = {
    environment       = local.environment
    product_name      = local.product_name
    short_description = local.short_description
    property          = lower(join(local.delimiter, local.property))
  }


  naming_selected = [for s in local.naming_order : local.namespace_context[s] if length(local.namespace_context[s]) > 0]


  namespace = lower(join(local.delimiter, local.naming_selected))


  namespace_ssm_parameter = format("%s${lower(join(local.ssm_delimiter, local.naming_selected))}", local.ssm_delimiter)

  # ---- ecs cluster and service naming ------#

  ecs_task_name    = format("td-%s", local.namespace)
  ecs_cluster_name = format("ecs-%s", local.namespace)

  ecs_service_name = format("svc-%s", local.naming_ecs_service)
  namespace_context_ecs_service = [
    local.environment,
    local.service_name,
    local.short_description
  ]

  naming_ecs_service = lower(join(local.delimiter, local.namespace_context_ecs_service))


  # ---- rds instance naming ------#

  # rds_identifier    = format("rds%s-%s", var.db_engine_shortname[var.db_engine], local.namespace)
  # subnet_group_name = format("subg-%s", local.namespace)
  # parameter_group   = format("param-%s", local.namespace)

  # ---- alb ------#

  alb_name = format("alb-%s", local.namespace)
  #target_groupe_name = format("tg-%s-%s-%s", local.environment, local.service_name, local.port)

  # ---- route53 health check ---- #
  shield_route53_healthcheck_reference_name = substr("rhc-${local.environment}-${local.product_name}-shield", 0, 26)
  shield_route53_healthcheck_name           = format("rhc-%s", "${local.environment}-${local.product_name}-shield")

}
