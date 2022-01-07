Terraform module to provision an HTTP style ALB ingress target and rules

Usage

IMPORTANT: The master branch is used in source just as an example. In your code, do not pin to master because there may be breaking changes between releases. Instead pin to the release tag (e.g. ?ref=tags/x.y.z) of one of our latest releases.

For example given this tfvars with a variable `action`  and a variable named `ingress_target` this is how you define your weighted target group with module and let the module create two target as follow:

```hcl
action = [
    type = "forward",
    forward = [{
        target_group = {
            blue  = { weight = 100}, # live target_group
            green = { weight =   0}, # staging target_group
        },
        stickiness = [{
            duration = 60
            enabled  = true
        }]
    }]
]

ingress_target = [
  { variant = "blue",  name = var.target_name, target_port = var.port, target_type = var.type, protocol = var.procotol
    health_check = { path = "/isAlive", interval: 15} },

  { variant = "green", name = var.target_name, target_port = var.port, target_type = var.type, protocol = var.procotol
    health_check = { path = "/isAlive", interval: 15} }
]

```

```hcl
   provider "aws" {
     region = var.region
  }

module "ingress_target" {
  source               = "git@gitlab.cmacgm.com:cloud-devops/terraform-modules/alb.git//alb-ingress-target-rules?ref=v3.1.0"
  listener_arn         = data.aws_lb_listener.selected.arn
  ingress_target       = var.ingress_target
  action               = var.action
  vpc_id               = module.network.vpc_id
  listener_conditions = [{
      host_header = [{  
        values = [format("%s-%s.*.cmacgm.com", module.naming.short_description, module.naming.product_name)] 
      }]
  },]
  tags = module.naming.tags
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
| action | dynamic action applied to blue/green target\_group traffic registered with a listener | <pre>set(object({<br>    type = string<br>    forward = list(object({<br>      target_group = map(object({<br>        weight = number<br>      }))<br>      stickiness = list(object({<br>        duration = number<br>        enabled  = bool<br>      }))<br>    }))<br>  }))</pre> | <pre>[<br>  {<br>    "forward": [],<br>    "type": "forward"<br>  }<br>]</pre> | no |
| deregistration\_delay | The amount of time to wait in seconds before remonving the container from the target | `number` | `300` | no |
| ingress\_target | (optional) target group parameter | <pre>set(object({<br>    variant      = string<br>    health_check = map(string)<br>    name         = string<br>    target_port  = number<br>    target_type  = string<br>    protocol     = string<br>  }))</pre> | n/a | yes |
| lambda\_multi\_value\_headers\_enabled | (optional) | `bool` | `null` | no |
| listener\_arn | Listener to add the rule(s) to | `string` | n/a | yes |
| listener\_conditions | List of conditions for the rule to be applied | `set(map(list(map(set(string)))))` | `[]` | no |
| load\_balancing\_algorithm\_type | (optional) | `string` | `null` | no |
| priority | priority applied to this rule | `number` | `null` | no |
| proxy\_protocol\_v2 | (optional) | `bool` | `null` | no |
| slow\_start | (optional) | `number` | `null` | no |
| stickiness | define the stickiness parameter such as duration and type : i.e type = lb\_cookie , duration= 86400 | <pre>object({<br>    enabled  = bool<br>    duration = number<br>    type     = string<br>  })</pre> | <pre>{<br>  "duration": 60,<br>  "enabled": true,<br>  "type": "lb_cookie"<br>}</pre> | no |
| tags | A list of tags to apply to the ecr repo | `map(string)` | `{}` | no |
| vpc\_id | The VPC ID where generated ALB target group will be provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| target\_group\_list\_arns | simple list of target group arns |
| target\_group\_map | map of arns define as key => value with key = variant and value = arn |
| target\_group\_map\_variant | map of target group identified by their key (`variant`) and value contaning the name, arn and id |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->