output "ecs_service_name" {
  value = aws_ecs_service.app_with_lb_awsvpc.name
}
