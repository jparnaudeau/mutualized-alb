######################################
# Retrieve the tfstate for LoadBalancer Component
######################################
data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "cmacmg-test-tfstates"
    key    = "ingress-alb/terraform.tfstate"
    region = "eu-west-3"
    skip_metadata_api_check = true
  }
}

##################################################################
# Data sources to get VPC, subnets, R53 domain
##################################################################
data "aws_vpc" "default" {
  default = true
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

##########################################
# Retrieve the get-caller-identify
##########################################
data "aws_caller_identity" "current" {
}

##########################################
# Retrieve the ELB service account infos
##########################################
data "aws_elb_service_account" "main" {
}

##########################################
# Retrieve the region where we are
##########################################
data "aws_region" "current" {}