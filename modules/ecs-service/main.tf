# Make an LB connected service dependent of this rule
# This to make sure the Target Group is linked to a Load Balancer before the aws_ecs_service is created
resource "null_resource" "aws_lb_listener" {
  triggers = {
    listeners = var.aws_lb_listener
  }
}

locals {
  # service_registries block does not accept a port with "A"-record-type
  # Setting the port to false works through a local
  service_registries_container_port = {
    "SRV" = var.container_port
    "A"   = false
  }
}

resource "aws_service_discovery_service" "service" {
  count = var.service_discovery_enabled ? 1 : 0

  name = var.name

  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = var.service_discovery_dns_ttl
      type = var.service_discovery_dns_type
    }

    routing_policy = var.service_discovery_routing_policy
  }

  health_check_custom_config {
    failure_threshold = var.service_discovery_healthcheck_custom_failure_threshold
  }

}

resource "aws_ecs_service" "app_with_lb_awsvpc" {
  name    = var.name
  cluster = var.cluster_id

  task_definition                    = var.selected_task_definition
  desired_count                      = var.desired_capacity
  launch_type                        = "FARGATE"
  scheduling_strategy                = var.scheduling_strategy
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
//  propagate_tags = "SERVICE"
  health_check_grace_period_seconds  = (var.lb_target_group_arn != "") ? var.health_check_grace_period_seconds: null

  deployment_controller {
    type = var.deployment_controller_type
  }

  dynamic "load_balancer" {
    for_each = var.lb_target_group_arn == "" ? [] : [1]
    content {
      target_group_arn = var.lb_target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  dynamic "service_registries" {
    for_each = var.service_discovery_enabled ? [1] : []
    content {
      registry_arn   = aws_service_discovery_service.service[0].arn
//      container_port = var.container_port
      container_name = var.container_name
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  network_configuration {
    subnets         = var.awsvpc_subnets
    security_groups = var.awsvpc_security_group_ids
  }

//  tags = merge(
//    var.tags,
//    {
//      Name = "${var.name}-service"
//    },
//  )

  depends_on = [null_resource.aws_lb_listener]
}
