## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| additional\_tags | Additional tags if you want. | map(string) | `<map>` | no |
| alb\_internal | If this variable is 'true' the ALB will be internal, therefore not exposed on the internet. | bool | `"true"` | no |
| alb\_s3\_access\_log\_bucket\_name | The S3 bucket name to store the access logs. | string | n/a | yes |
| alb\_s3\_access\_log\_prefix | The PATH in S3 bucket to store access logs. | string | `""` | no |
| alb\_security\_groups\_id | Security groups ID. | list(string) | n/a | yes |
| enable\_cross\_zone\_load\_balancing | If true, cross-zone load balancing of the load balancer will be enabled. This is a network load balancer feature. Defaults to 'true'. | bool | `"true"` | no |
| enable\_deletion\_protection | If true, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to false. | bool | `"false"` | no |
| enable\_http2 | Indicates whether HTTP/2 is enabled in application load balancers. Defaults to true. | bool | `"true"` | no |
| environment | Environment name. | string | n/a | yes |
| idle\_timeout | The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type application. Default: 60. | number | `"60"` | no |
| ip\_address\_type | The type of IP addresses used by the subnets for your load balancer. The possible values are ipv4 and dualstack. | string | `"ipv4"` | no |
| principal\_tags | Local common tags. | map(string) | n/a | yes |
| product\_name | Product name name, such as Team name. | string | n/a | yes |
| region | Region identifier. | string | n/a | yes |
| short\_description | Short description of your fonctionality | string | n/a | yes |
| subnets | List of subnets | list(string) | n/a | yes |
| waf\_web\_acl\_id | WAF Web ACL ID required for an external ALB. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| load\_balancer\_arn | The ARN of the load balancer |
| load\_balancer\_arn\_suffix | The ARN suffix for use with CloudWatch Metrics. |
| load\_balancer\_dns\_name | The DNS name of the load balancer. |
| load\_balancer\_id | The ARN of the load balancer. |
| load\_balancer\_zone\_id | The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record). |

