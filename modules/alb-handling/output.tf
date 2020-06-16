output "lb_target_group_arn" {
  value = concat(aws_lb_target_group.service[*].arn, [""])[0]
}

output "lb_listener_arn" {
  value = concat(aws_lb_listener.front_end_https[*].arn, [""])[0]
}
