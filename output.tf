output "lb_target_group_arn" {
  value = module.alb_handling.lb_target_group_arn
}

output "https_listener_arn" {
  value = module.alb_handling.lb_listener_arn
}