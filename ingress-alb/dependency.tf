##################################################################
# Data sources to get VPC, subnets, R53 domain
##################################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

resource "random_pet" "this" {
  length = 2
}

data "aws_route53_zone" "this" {
  name = var.domain_name
}

##########################################
# The module for generated name according to naming convention
##########################################
module "naming" {
  source = "../modules/naming"

  environment       = var.environment
  product_name      = var.product_name
  short_description = var.short_description
  costcenter        = var.costcenter
  owner             = var.owner
}
