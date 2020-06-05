output "ecs_task_execution_role_arn" {
  description = "ecs_task_execution_role_arn outputs the Role-Arn for the ECS Task Execution role."
  value       = aws_iam_role.ecs_service.arn
}

output "ecs_task_execution_role_name" {
  description = "ecs_task_execution_role_arn outputs the Role-name for the ECS Task Execution role."
  value       = aws_iam_role.ecs_service.name
}

output "ecs_taskrole_arn" {
  description = "ecs_taskrole_arn outputs the Role-Arn of the ECS Task"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_taskrole_name" {
  description = "ecs_taskrole_name outputs the Role-name of the ECS Task"
  value       = aws_iam_role.ecs_task_role.name
}
