output "lb_target_group_arn" {
  value = concat(aws_alb_target_group.service[*].arn, [""])[0]
}

output "lb_listener" {
  value = lookup(element(aws_alb_listener.front_end_https.*, 0), "arn", "")
}
