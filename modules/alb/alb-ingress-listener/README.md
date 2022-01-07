Terraform module to provision an HTTP style ALB ingress listener

Usage

IMPORTANT: The master branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. ?ref=tags/x.y.z) of one of our latest releases.

For a complete example, see examples/complete.

```hcl

module "example_ingress_listener" {
  source                = "git@gitlab.acme.com:cloud-devops/terraform-modules/alb.git//alb-ingress-listener?ref=v3.1.0"
  namespace             = module.naming.namespace
  alb_loadbalancer_arn  = module.example_alb.load_balancer_arn
  alb_security_group_id = module.example_alb.alb_security_group_id
  https_listener_ports_and_certs = [{
    port     = 443
    cert_arn = aws_acm_certificate.alb_acm_certificate[0].arn
  }]
  allow_inbound_from_cidr_blocks = [
    {label = "work1", cidrs = ["172.16.29.0/24"],  description = "citrix view internal"},
    {label = "work2", cidrs = ["10.22.64.0/18"], description = "citrix view external"}
  ]
  #allow_inbound_from_cidr_blocks = var.allow_inbound_from_cidr_blocks
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| aws | >= 3, < 4 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3, < 4 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_alb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) |
| [aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_loadbalancer\_arn | Arn of the ALB this resources apply to | `string` | n/a | yes |
| alb\_security\_group\_id | The alb security group to be applied to security\_group\_rules in this modules | `string` | n/a | yes |
| allow\_inbound\_from\_cidr\_blocks | A list of IP addresses in CIDR notation from which the load balancer will allow incoming HTTP/HTTPS requests. | <pre>set(object({<br>    label       = string<br>    cidrs       = list(string)<br>    description = string<br>  }))</pre> | `[]` | no |
| allow\_inbound\_from\_security\_groups | A list of Security Group IDs from which the load balancer will allow incoming HTTP/HTTPS requests. Any time you change this value, make sure to update var.allow\_inbound\_from\_security\_groups too! | <pre>set(object({<br>    label       = string<br>    secgroup    = string<br>    description = string<br>  }))</pre> | `[]` | no |
| fixed\_response | define the fixed\_response parameter such as content\_type, message\_body and status\_code | <pre>object({<br>    content_type = string<br>    message_body = string<br>    status_code  = string<br>  })</pre> | <pre>{<br>  "content_type": "text/plain",<br>  "message_body": "404: Nothing to see here. This is unfortunate",<br>  "status_code": 404<br>}</pre> | no |
| http\_listener\_ports | A list of ports to listen on for HTTP requests. | `set(string)` | `[]` | no |
| https\_listener\_ports\_and\_certs | A list of objects that define the ports to listen on for HTTPS requests. Each object should have the keys 'port' (the port number to listen on) and 'certificate\_arn' (the ARN of an ACM or IAM TLS cert to use on this listener). | <pre>set(object({<br>    port     = number<br>    cert_arn = string<br>  }))</pre> | `[]` | no |
| https\_ssl\_policy | The name of the SSL Policy for the listener | `string` | `"ELBSecurityPolicy-TLS-1-2-Ext-2018-06"` | no |
| namespace | for standard alb naming | `string` | n/a | yes |
| redirect | (optional) control activation of ingress redirect traffic to https | <pre>object({<br>    enabled     = bool<br>    port        = string<br>    protocol    = string<br>    status_code = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "port": "443",<br>  "protocol": "HTTPS",<br>  "status_code": "HTTP_301"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| https\_listener\_arn | The ARN of the HTTPS listener |
| https\_listener\_arn\_map | The map ARN of the HTTPS listener, the key of the map is the port of your listener |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->