
<div align="center">

<p align="center"> <img src="./docs/terraform-logo-black.png" width="100" height="100"></p>

<h1 align="center">
    Terraform Naming
</h1>

<p align="center" style="font-size: 1.2rem;">
This terraform module is designed to generate consistent label names and tags for resources. You can use naming module to implement a strict naming convention in order to be compliant with the landing zone convention
</p>

<p align="center">

<a href="https://gitlab.cmacgm.com/cloud-devops/terraform-modules/naming/-/commits/master">
  <img src="https://gitlab.cmacgm.com/cloud-devops/terraform-modules/naming/badges/master/pipeline.svg" alt="pipeline status">
</a>

<a href="https://www.terraform.io">
  <img src="./docs/terraform-014.svg" alt="Terraform">
</a>

</p>

</div>

<hr>

# Naming Convention

Now instead of having to pass and hard code inside every module 4 or 5 variables to build a compliant name; you just pass those variables to the naming module and the ouput will be a namespace variable which  will contain the interpolated value provided as input, it generate for example this naming convention:

````
${environment}-${product_name}-${short_description}-{cluster_function}

${environment}-${product_name}-${short_description}-{property}

${environment}-${product_name}-${service_name}-{property}

````

This module manage the following resources:

- namespace: the name corresponding to the convention per module or project or organisation bases.
- namespace_ssm_parameter: ssm parameter store path key identifier
- tags : the tags corresponding to the convention you apply in your organisation
- tags_for_asg: tags as needed in AutoScaling Group
- label : a map containing all the common value for tags

This module is inspired by <https://github.com/cloudposse/terraform-null-label>

## Usage

### :warning: Important note

To better control module versions & avoid unexpected breaking failure to your infrastructure, we highly recommand you using **explicitly a version tag of this module** instead of branch reference since the latter is changing frequently. (use **ref=v3.0.0**,  dont use **ref=master**)

#### Examples

let's take the following usage code snipet, for naming and tagging of rds postgres instance resource.

```hcl

module "naming" {
  source      = "git@gitlab.cmacgm.com:cloud-devops/terraform-modules/naming.git?ref=v1.0.0"
  environment         = var.environment
  product_name        = var.product_name
  short_description   = var.short_description
  property            = ["00"]
  costcenter          = var.costcenter
  owner               = var.owner
}
````

Passing the below value to the module.

- environment       = "dev"
- product_name      = "superapp"
- short_description = "api"
- property          = ["00"]

 will ouput a **`namespace`** = "dev-superapp-api-00" variable and that could produce, an rds instance identifier  like this:

````
rdsp-dev-superapp-api-00 -> rdsp-${environement}-${product_name}-${short_description}-${db_numerical_version}
````

so the input to the rds module you will use with the naming module would look like this:

```hcl

module "rds" {
    source     = "source"
    identifier = module.naming.namespace
    tags       = module.naming.tags
    etc ...
    ...
    ...
    ...
}
```

### Take away

The namespace value is composed of :

- environment : dev
- product_name : supperapp
- short_description : api
- property : 00 (db_numerical_version)

But the namespace can also be something else depending on the naming convention of the stack you try to build

for example :

namespace can be :

- environment : dev
- product_name : supperapp
- cluster_function : api
- property : ecs (db_numerical_version)

### NB

All the field are respect a particular order, the naming module by convention follow this order

```hcl
naming_order = ["environment", "product_name", "service_name", "short_description", "cluster_function", "property"]
````

If you don't specify a value it will be just ignore.

## Inputs & outputs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.0, <= 0.15 |

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_asg\_tag | Additional tags for appending to each tag map, fo ASG resources | `map(string)` | `{}` | no |
| app\_sn | Standard app\_sn attribute | `string` | `""` | no |
| cluster\_function | Standard cluster\_function attribute | `string` | `""` | no |
| costcenter | Standard short\_description attribute | `string` | `""` | no |
| db\_engine\_shortname | n/a | `map(string)` | <pre>{<br>  "mariadb": "ma",<br>  "mysql": "m",<br>  "postgres": "p",<br>  "sqlserver-ee": "s",<br>  "sqlserver-se": "s",<br>  "sqlserver-web": "s"<br>}</pre> | no |
| delimiter | Delimiter to be used between `environment`, `product_name`, `short_description` and `property` | `string` | `"-"` | no |
| environment | Standard environment attribute | `string` | `""` | no |
| naming\_order | The naming order of the namespace output used on every resources names | `list(string)` | `[]` | no |
| owner | Standard owner attribute | `string` | `""` | no |
| product\_name | Standard product\_name attribute | `string` | `""` | no |
| property | Additional property attributes (e.g. `public`, `cicd`, `snapshot`, `master`, `shared`, `standalone`) | `list(string)` | `[]` | no |
| route53\_environment | (optional) describe your variable | `string` | `null` | no |
| s3bucket\_environment | (optional) describe your variable | `string` | `null` | no |
| service\_name | Standard service\_name attribute | `string` | `""` | no |
| short\_description | Standard short\_description attribute | `string` | `""` | no |
| tags | Additional tags (e.g. `map('BusinessLine','Prevoyance')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb\_name | the ecs standard service name |
| application | Standard application label |
| costcenter | Standard costcenter label |
| ecs\_cluster\_name | the ecs standard cluster name |
| ecs\_service\_name | the ecs standard service name |
| ecs\_task\_name | the ecs standard service name |
| environment | Standard environment label |
| label | Standard namespaces label containing all the common standard attributes |
| namespace | Standard namespace label |
| namespace\_ssm\_parameter | Standard namespace label for SSM parameter store PATH Key indentifier |
| namespaces | Standard namespaces label containing all the common standard attributes |
| owner | Standard owner label |
| product\_name | Standard product\_name label |
| property | Standard list of properties |
| route53\_environment | Route53 environment (dev02) |
| s3bucket\_environment | S3 bucket environment (dev02) |
| service\_name | the non standard service name suffix |
| shield\_route53\_healthcheck\_name | Name for Route53 health check (mandatory for all public resources) |
| shield\_route53\_healthcheck\_reference\_name | Reference name for Route53 health check (mandatory for all public resources) |
| short\_description | Standard short\_description label |
| stage | n/a |
| tags | Standard Tag map |
| tags\_for\_asg | Additional standard tags as a list of maps for autoscaling groups |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Release notes

Release notes are available [here (link to update)](??/-/releases).

## Bug Reports & Feature Requests

Bug reports & feature requests should be reported in gitlab [here (link to update)](??/issues), before submitting an issue or a merge request, please check our [submission guidlines](CONTRIBUTING.md)

## Contributing

The CloudFoundation is a small team that cannot garantee maintaining and imporving all ouf our terraform module portofilio. To build more comprehensive & better terraform modules by adding and laveraging features that meet your business cases, we need your contribution to maintain & move toward our DevOps accelerator portofolio.

We are adopting an open source approach, where **every single Dev(Ops) @** can "Commit" to **every terraform module**, we are confident this approach will lead to higher-quality modules but also will make it easier to use thoses modules.

**You want to participate ?** Checkout our guidlines for [contributing](CONTRIBUTING.md).
