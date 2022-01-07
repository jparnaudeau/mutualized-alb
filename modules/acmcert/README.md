## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns\_ttl | The TTL of DNS recursive resolvers to cache information about this record. | `number` | `60` | no |
| domain\_zone\_id | The route53 domain hosted zoneId | `string` | n/a | yes |
| domains | The dns main domain and subject alternatives names to issue tls certificate | <pre>set(object({<br>    name              = string<br>    primary_domain    = string<br>    alternative_names = set(string)<br>    validation_method = string<br>    options = set(object({<br>      certificate_transparency_logging_preference = string<br>    }))<br>    listener = object({<br>      port    = number<br>      alb_arn = string<br>    })<br>  }))</pre> | n/a | yes |
| tags | The common conventional tags | `map(string)` | n/a | yes |
| timeouts | n/a | <pre>set(object({<br>    create = string<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| acm\_certificate\_arn | The certificate arn |
| certificate\_validation | n/a |
| data\_listener | n/a |
| listener\_certificate | n/a |
| records\_validation | n/a |

