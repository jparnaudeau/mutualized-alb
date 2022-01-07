###################################################################
# Create a SecurityGroup for our ALB
###################################################################
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "alb-sg-${random_pet.this.id}"
  description = "Security group for example usage with ALB"
  vpc_id      = data.aws_vpc.default.id

  #ingress_cidr_blocks = var.allow_inbound_from_cidr_blocks
  #ingress_rules       = ["https-443-tcp"]
  egress_rules        = ["all-all"]
}



###################################################################
# Create a bucket to store ALB Access Logs
###################################################################
module "log_bucket" {
   source  = "terraform-aws-modules/s3-bucket/aws"
   version = "2.10.0"

   bucket                         = "logs-${random_pet.this.id}"
   acl                            = "log-delivery-write"
   force_destroy                  = true
   attach_elb_log_delivery_policy = true
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = var.domain_name # trimsuffix(data.aws_route53_zone.this.name, ".") # Terraform >= 0.12.17
  zone_id     = data.aws_route53_zone.this.id
}

##################################################################
# Application Load Balancer
##################################################################
locals {
  alb_namespace_standard = format("%s-%s-%s",var.environment,var.application_short_name,var.short_description)
}

module "alb" {
  source          = "../modules/alb/alb"
  namespace       = var.custom_alb_name == "" ? local.alb_namespace_standard : var.custom_alb_name
  domain_zone     = var.domain_name
  vpc_id          = data.aws_vpc.default.id
  subnet_ids      = data.aws_subnet_ids.all.ids
  security_groups = [module.security_group.security_group_id]
  is_private_zone = false
  tags            = module.naming.tags
  access_logs = [{
    enabled = true
    bucket  = module.log_bucket.s3_bucket_id
    prefix  = format("alb-%s", module.naming.namespace)
  }]
}

##################################################################
# Create HTTPS Listener on ALB
##################################################################
module "ingress_listener" {
  source                = "../modules/alb/alb-ingress-listener"
  namespace             = module.naming.namespace
  alb_loadbalancer_arn  = module.alb.load_balancer_arn
  alb_security_group_id = module.security_group.security_group_id
  https_listener_ports_and_certs = [{
    port     = var.listener_port
    #cert_arn = aws_acm_certificate.alb_acm_certificate.arn
    cert_arn = module.acm.acm_certificate_arn
  }]
  allow_inbound_from_cidr_blocks = [{
    label = "https"
    cidrs = var.allow_inbound_from_cidr_blocks
    description = "legitimate traffic"
  }]
}
