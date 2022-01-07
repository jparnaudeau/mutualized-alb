Terraform module to provision an HTTP ALB

Usage

IMPORTANT: The master branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. ?ref=tags/x.y.z) of one of our latest releases.

For a complete example, see examples/complete.

```hcl
   provider "aws" {
     region = var.region
  }

module "alb" {
  source          = "git@gitlab.cmacgm.com:cloud-devops/terraform-modules/alb.git//alb?ref=v3.1.0"
  namespace       = module.naming.namespace
  domain_zone     = module.network.domain_zone_name
  vpc_id          = module.network.vpc_id
  subnet_ids      = module.network.private_subnet_ids
  is_private_zone = false
  access_logs     = {
    enabled  = true
    bucket   = module.access_logs.access_log_bucket_name
    prexfix  = format("alb-%s", module.naming.namespace)
  }
  tags            = module.naming.tags
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| aws | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) |
| [aws_route53_health_check](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_health_check) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |
| [aws_wafregional_web_acl_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafregional_web_acl_association) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_logs | nested object for defining access log | <pre>set(object(<br>    {<br>      bucket  = string<br>      enabled = bool<br>      prefix  = string<br>    }<br>  ))</pre> | `[]` | no |
| custom\_alb\_name | custom alb name | `string` | `""` | no |
| custom\_alb\_records | optional custom domain name | `string` | `""` | no |
| domain\_zone | The domain hosted zone of this environment | `string` | `null` | no |
| drop\_invalid\_header\_fields | Indicates whether invalid header fields are dropped in application load balancers. Defaults to false. | `bool` | `false` | no |
| egress\_cidr\_blocks | The list of cidr for alb outbound traffic | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| enable\_alb\_alias | (optional) true or false to allow creation friendly alias record for alb | `bool` | `true` | no |
| enable\_cross\_zone\_load\_balancing | If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to 'true'. | `bool` | `true` | no |
| enable\_deletion\_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | `bool` | `false` | no |
| enable\_http2 | Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true. | `bool` | `true` | no |
| idle\_timeout | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60. | `number` | `60` | no |
| ip\_address\_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | `string` | `"ipv4"` | no |
| is\_alb\_internal | If this variable is 'true' the ALB will be internal, therefore not exposed on the internet. | `bool` | `true` | no |
| is\_private\_zone | This variable indicate if route53 alias record for the alb is part of public or private hosted\_zone domain | `bool` | `false` | no |
| load\_balancer\_type | (optional) | `string` | `"application"` | no |
| namespace | for standard alb naming | `string` | n/a | yes |
| region | Region identifier. | `string` | `"eu-central-1"` | no |
| revoke\_rules\_on\_delete | allow to revoke rule on delete | `bool` | `true` | no |
| shield\_health\_check\_failure\_threshold | The number of consecutive health checks that an endpoint must pass or fail. | `string` | `"3"` | no |
| shield\_health\_check\_interval | The number of seconds between the time that Amazon Route 53 gets a response from your endpoint and the time that it sends the next health-check request. | `string` | `"30"` | no |
| shield\_health\_check\_measure\_latency | A Boolean value that indicates whether you want Route 53 to measure the latency between health checkers in multiple AWS regions and your endpoint and to display CloudWatch latency graphs in the Route 53 console. | `bool` | `true` | no |
| shield\_health\_check\_path | The path that you want Amazon Route 53 to request when performing health checks. | `string` | `""` | no |
| shield\_health\_check\_port | The port of the endpoint to be checked. | `number` | `443` | no |
| shield\_health\_check\_type | The protocol to use when performing health checks. Valid values are HTTP, HTTPS | `string` | `"HTTPS"` | no |
| shield\_route53\_healthcheck\_name | for shield route53 healthcheck naming | `string` | n/a | yes |
| shield\_route53\_healthcheck\_reference\_name | for shield route53 healthcheck reference naming | `string` | n/a | yes |
| subnet\_ids | List of subnets | `list(string)` | n/a | yes |
| subnet\_mapping | nested mode: NestingSet | <pre>set(object({<br>    allocation_id        = string<br>    private_ipv4_address = string<br>    subnet_id            = string<br>  }))</pre> | `[]` | no |
| tags | common tags. | `map(string)` | n/a | yes |
| timeouts | resource creation timeouts | <pre>set(object(<br>    {<br>      create = string<br>      delete = string<br>      update = string<br>    }<br>  ))</pre> | `[]` | no |
| vpc\_id | the vpc\_id where this lb will be provision | `string` | n/a | yes |
| waf\_web\_acl\_id | WAF Web ACL ID required for an external ALB. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_alias\_fqdn | The route53 record alias FQDN of the load balancer. |
| alb\_alias\_name | The route53 record alias name of the load balancer. |
| alb\_alias\_zone\_id | The route53 record alias zoneId of the load balancer. |
| alb\_security\_group\_id | The security groupId of the load balancer. |
| load\_balancer\_arn | The ARN of the load balancer |
| load\_balancer\_arn\_suffix | The ARN suffix for use with CloudWatch Metrics. |
| load\_balancer\_dns\_name | The amazon DNS name of the load balancer. |
| load\_balancer\_id | The ARN of the load balancer. |
| load\_balancer\_zone\_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->