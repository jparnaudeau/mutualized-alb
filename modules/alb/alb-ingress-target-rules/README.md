Terraform module to provision an HTTP style ALB ingress target and rules

Usage

IMPORTANT: The master branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. ?ref=tags/x.y.z) of one of our latest releases.

For a complete example, see examples/complete.

```hcl
   provider "aws" {
     region = var.region
  }

module "ingress_target" {
  source               = "git@gitlab.cmacgm.com:cloud-devops/terraform-modules/alb.git//alb-ingress-target-rules?ref=v3.1.0"
  alb_loadbalancer_arn = module.example_alb.load_balancer_arn
  target_group_name    = format("tg-%s-%s", "api", var.product_name)
  target_group_port    = var.target_group_port
  target_type          = var.target_type
  alb_listener_arn     = module.ingress_listener.https_listener_arn
  vpc_id               = module.network.vpc_id
  health_check         = var.health_check
  listener_conditions = [
    {
      host_header = [format("%s-%s.*.cmacgm.com", "api", var.product_name)]
    },
  ]
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
| [aws_alb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_listener\_arn | Listener to add the rule(s) to | `string` | n/a | yes |
| alb\_loadbalancer\_arn | Arn of the ALB this resources apply to | `string` | n/a | yes |
| deregistration\_delay | The amount of time to wait in seconds before remonving the container from the target | `number` | `300` | no |
| health\_check | The default target group's health check configuration, will be merged over the default (see locals.tf) | `map(string)` | `{}` | no |
| lambda\_multi\_value\_headers\_enabled | (optional) | `bool` | `null` | no |
| listener\_conditions | List of conditions for the rule to be applied | `list(map(list(string)))` | `[]` | no |
| load\_balancing\_algorithm\_type | (optional) | `string` | `null` | no |
| name\_prefix | (optional) | `string` | `null` | no |
| proxy\_protocol\_v2 | (optional) | `bool` | `null` | no |
| slow\_start | (optional) | `number` | `null` | no |
| start\_priority | priority applied to this rule | `number` | `99` | no |
| stickiness | define the stickiness parameter such as duration and type : i.e type = lb\_cookie , duration= 86400 | <pre>object({<br>    enabled  = bool<br>    duration = number<br>    type     = string<br>  })</pre> | <pre>{<br>  "duration": 86400,<br>  "enabled": false,<br>  "type": "lb_cookie"<br>}</pre> | no |
| tags | A list of tags to apply to the ecr repo | `map(string)` | `{}` | no |
| target\_group\_name | Name of the target group | `string` | n/a | yes |
| target\_group\_port | The listen port on the target group destination | `number` | `80` | no |
| target\_group\_protocol | The protocol for the created target group | `string` | `"HTTP"` | no |
| target\_type | The type (`instance`, `ip` or `lambda`) of targets that can be registered with the target group | `string` | `"instance"` | no |
| vpc\_id | The VPC ID where generated ALB target group will be provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_arn | The target group ARN |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->