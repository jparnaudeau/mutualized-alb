

output "target_group_map_variant" {
  value = { for key, value in(aws_lb_target_group.ingress_target) :
    key => {
      target_group_arn  = value.arn
      target_group_name = value.name
      target_group_id   = value.id
    }
  }
  description = "map of target group identified by their key (`variant`) and value contaning the name, arn and id"
}


output "target_group_list_arns" {
  value       = [for target in values(aws_lb_target_group.ingress_target)[*] : target.arn]
  description = "simple list of target group arns"
}


output "target_group_map" {
  value       = { for key, value in(aws_lb_target_group.ingress_target) : key => value.arn }
  description = "map of arns define as key => value with key = variant and value = arn"
}
