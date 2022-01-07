## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.63.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 3.0 |
| <a name="module_alb"></a> [alb](#module\_alb) | ../modules/alb/alb | n/a |
| <a name="module_ingress_listener"></a> [ingress\_listener](#module\_ingress\_listener) | ../modules/alb/alb-ingress-listener | n/a |
| <a name="module_log_bucket"></a> [log\_bucket](#module\_log\_bucket) | terraform-aws-modules/s3-bucket/aws | 2.10.0 |
| <a name="module_naming"></a> [naming](#module\_naming) | ../modules/naming | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnet_ids.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_inbound_from_cidr_blocks"></a> [allow\_inbound\_from\_cidr\_blocks](#input\_allow\_inbound\_from\_cidr\_blocks) | A list of IP addresses in CIDR notation from which the load balancer will allow incoming HTTP/HTTPS requests. | `list(string)` | `[]` | no |
| <a name="input_application_short_name"></a> [application\_short\_name](#input\_application\_short\_name) | Application Short name (used in alb name) | `string` | n/a | yes |
| <a name="input_costcenter"></a> [costcenter](#input\_costcenter) | CostCenter | `string` | n/a | yes |
| <a name="input_custom_alb_name"></a> [custom\_alb\_name](#input\_custom\_alb\_name) | Keep possibility to override alb namespace | `string` | `""` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The R53 domain name | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Envrionment name. Ie: dev, sandbox, ... | `string` | n/a | yes |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | The port on which the listener is created. By default, 443 | `number` | `443` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Email of the team owning application | `string` | n/a | yes |
| <a name="input_product_name"></a> [product\_name](#input\_product\_name) | Application | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region | `string` | `"eu-west-3"` | no |
| <a name="input_short_description"></a> [short\_description](#input\_short\_description) | The short description | `string` | `"stack"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_alias_fqdn"></a> [alb\_alias\_fqdn](#output\_alb\_alias\_fqdn) | The route53 record alias FQDN of the load balancer. |
| <a name="output_alb_alias_zone_id"></a> [alb\_alias\_zone\_id](#output\_alb\_alias\_zone\_id) | The route53 record alias zoneId of the load balancer. |
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | application loadbalancer arn |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | alb dns name |
| <a name="output_https_listener_arn"></a> [https\_listener\_arn](#output\_https\_listener\_arn) | The ARN of the HTTPS listener |
| <a name="output_https_listener_arn_map"></a> [https\_listener\_arn\_map](#output\_https\_listener\_arn\_map) | The map ARN of the HTTPS listener, the key of the map is the port of your listener |
| <a name="output_load_balancer_zone_id"></a> [load\_balancer\_zone\_id](#output\_load\_balancer\_zone\_id) | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |
