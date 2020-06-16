locals {
  ecs_cluster_name = basename(var.ecs_cluster_id)
  launch_type      = "FARGATE"

  name_map = {
    "Name" = "${local.ecs_cluster_name}-${var.name}"
  }

  ssl_enabled = var.load_balancing_properties_https_enabled == 1 ? 1 : 0
  lb_enabled = var.load_balancing_properties_enabled == 1 ? 1 : 0

  tags = merge(var.tags, local.name_map)
}

module "acm" {
  source = "./modules/acm"

  https_enabled = local.ssl_enabled

  cert_domain = var.load_balancing_properties_route53_custom_name

  cert_sans = var.load_balancing_properties_cert_sans

  r53_zone_id = var.load_balancing_properties_route53_zone_id

  tags = local.tags
}

module "alb_handling" {
  source = "./modules/alb-handling"

  name         = var.name
  cluster_name = local.ecs_cluster_name

  lb_enabled = local.lb_enabled

  ssl_enabled = local.ssl_enabled

  # lb_vpc_id sets the VPC ID of where the LB resides
  lb_vpc_id = var.load_balancing_properties_lb_vpc_id

  # lb_arn defines the arn of the LB
  lb_arn = var.load_balancing_properties_lb_arn

  cert_arn = module.acm.cert_arn

  # target_group_port sets the port of the target group, by default 80
  target_group_port = var.load_balancing_properties_target_group_port

  # unhealthy_threshold defines the threashold for the target_group after which a service is seen as unhealthy.
  unhealthy_threshold = var.load_balancing_properties_unhealthy_threshold

  healthy_threshold = var.load_balancing_properties_healthy_threshold

  # Sets the deregistration_delay for the targetgroup
  deregistration_delay = var.load_balancing_properties_deregistration_delay

  # Sets the zone in which the sub-domain will be added for this service
  route53_zone_id = var.load_balancing_properties_route53_zone_id

  # Sets name for the sub-domain, we default to *name
  route53_name = var.load_balancing_properties_route53_custom_name == "" ? var.name : var.load_balancing_properties_route53_custom_name

  # health_uri defines which health-check uri the target group needs to check on for health_check
  health_uri = var.load_balancing_properties_health_uri

  # health_port defines port of the health-check
  health_port = var.load_balancing_properties_health_port

  # The expected HTTP status for the health check to be marked healthy
  # You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299")
  health_matcher = var.load_balancing_properties_health_matcher

  # target_type in case of FARGATE it's IP
  target_type = "ip"

  tags = local.tags
}

module "ecs-service" {
  source = "./modules/ecs-service"

  name = var.name

  cluster_id = var.ecs_cluster_id

  selected_task_definition = var.ecs_task_definition_arn

  # deployment_controller_type sets the deployment type
  # ECS for Rolling update, and CODE_DEPLOY for Blue/Green deployment via CodeDeploy
  deployment_controller_type = var.deployment_controller_type

  # deployment_maximum_percent sets the maximum size of the deployment in % of the normal size.
  deployment_maximum_percent = var.capacity_properties_deployment_maximum_percent

  # deployment_minimum_healthy_percent sets the minimum % in capacity at deployment
  deployment_minimum_healthy_percent = var.capacity_properties_deployment_minimum_healthy_percent

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  # awsvpc_subnets defines the subnets for an awsvpc ecs module
  awsvpc_subnets = var.awsvpc_subnets

  # awsvpc_security_group_ids defines the vpc_security_group_ids for an awsvpc module
  awsvpc_security_group_ids = var.awsvpc_security_group_ids

  # lb_target_group_arn sets the arn of the target_group the service needs to connect to
  lb_target_group_arn = module.alb_handling.lb_target_group_arn

  # desired_capacity sets the initial capacity in task of the ECS Service, ignored when scheduling_strategy is DAEMON
  desired_capacity = var.capacity_properties_desired_capacity

  # scheduling_strategy
  scheduling_strategy = var.scheduling_strategy

  # container_name sets the name of the container, this is used for the load balancer section inside the ecs_service to connect to a container_name defined inside the
  # task definition, container_port sets the port for the same container.
  container_name = var.container_name

  container_port = var.container_port

  # This way we force the aws_lb_listener_rule to have finished before creating the ecs_service
  aws_lb_listener = module.alb_handling.lb_listener_arn

  # https://aws.amazon.com/blogs/aws/amazon-ecs-service-discovery/
  # service_discovery_enabled defaults to false
  service_discovery_enabled = var.service_discovery_enabled

  # Should error when service_discovery_enabled is set and no namespace_id is given
  service_discovery_namespace_id = var.service_discovery_properties_namespace_id

  # ttl of the service discovery records, default 60
  service_discovery_dns_ttl = var.service_discovery_properties_dns_ttl

  # dns_type defaults to A (AWSVPC)
  service_discovery_dns_type = var.service_discovery_properties_dns_type

  # service_discovery_properties_routing_policy
  service_discovery_routing_policy = var.service_discovery_properties_routing_policy

  # healthcheck_custom_failure_threshold needed, set to 1 by default
  service_discovery_healthcheck_custom_failure_threshold = var.service_discovery_properties_healthcheck_custom_failure_threshold

  # tags
  tags = local.tags
}
