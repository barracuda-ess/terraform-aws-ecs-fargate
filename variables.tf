variable "ecs_cluster_id" {
  description = "The cluster to which the ECS Service will be added"
}

variable "name" {
  description = "The name of the project, must be unique"
}

variable "region" {
  description = "Region of the ECS Cluster"
}

variable "container_name" {
  description = "Container name"
  default     = "app"
}

variable "container_port" {
  default     = ""
  description = "port defines the needed port of the container"
}

variable "scheduling_strategy" {
  default     = "REPLICA"
  description = "scheduling_strategy defaults to REPLICA"
}

variable "deployment_controller_type" {
  description = <<EOF
deployment_controller_type sets the deployment type
ECS for Rolling update, and CODE_DEPLOY for Blue/Green deployment via CodeDeploy
EOF

  default = "ECS"
}

variable "load_balancing_properties_enabled" {
  description = "Indicate if load-balancing is enabled"
  default = false
}

variable "load_balancing_properties_lb_arn" {
  description = "The arn of the ALB or NLB being used"
  default     = ""
}

variable "load_balancing_properties_https_enabled" {
  description = "indicates if https is enabled or not"
  default = false
}

variable "load_balancing_properties_cert_sans" {
  description = "SANS for ACM cert"
  type = list
  default = []
}

variable "load_balancing_properties_route53_record_type" {
  description = "By default we create an ALIAS to the ALB, this can be set to CNAME, or NONE to not create any records"
  default     = "ALIAS"
}

variable "load_balancing_properties_route53_custom_name" {
  description = "By default we create a subdomain with using var.name, override with load_balancing_properties_route53_custom_name"
  default     = ""
}

variable "load_balancing_properties_target_group_port" {
  description = "target_group_port sets the port for the alb or nlb target group, this generally can stay 80 regardless of the service port"
  default     = "80"
}

variable "load_balancing_properties_lb_vpc_id" {
  description = "lb_vpc_id is the vpc_id for the target_group to reside in"
  default     = ""
}

variable "load_balancing_properties_route53_zone_id" {
  description = "route53_zone_id is the zone to add a subdomain to"
  default     = ""
}

variable "load_balancing_properties_health_uri" {
  description = "health_uri is the health uri to be checked by the ALB"
  default     = "/ping"
}

variable "load_balancing_properties_health_matcher" {
  description = "health_matcher sets the expected HTTP status for the health check to be marked healthy"
  default     = "200"
}

variable "load_balancing_properties_health_port" {
  description = "health_port is the port of health uri to be checked by the ALB"
  default     = "traffic-port"
}

variable "load_balancing_properties_unhealthy_threshold" {
  description = "The number of consecutive successful health checks required before considering an healthy target unhealthy"
  default     = "3"
}

variable "load_balancing_properties_healthy_threshold" {
  description = "The number of consecutive successful health checks required before considering an unhealthy target healthy"
  default     = "3"
}

variable "load_balancing_properties_deregistration_delay" {
  description = "load_balancing_properties_deregistration_delay sets the deregistration_delay for the targetgroup"
  default     = 300
}

variable "load_balancing_properties_route53_record_identifier" {
  description = "route53_record_identifier sets the A ALIAS record identifier"
  default     = "identifier"
}

variable "capacity_properties_desired_capacity" {
  description = "capacity_properties_desired_capacity is the desired amount of tasks for a service, when autoscaling is used desired_capacity is only used initially"
  default     = "2"
}

variable "capacity_properties_desired_min_capacity" {
  description = "capacity_properties_desired_min_capacity is used when autoscaling is activated, it sets the minimum of tasks to be available for this service"
  default     = "2"
}

variable "capacity_properties_desired_max_capacity" {
  description = "capacity_properties_desired_max_capacity is used when autoscaling is activated, it sets the maximum of tasks to be available for this service"
  default     = "2"
}

variable "capacity_properties_deployment_maximum_percent" {
  description = "capacity_properties_deployment_maximum_percent sets the maximum deployment size of the current capacity, 200% means double the amount of current tasks"
  default     = "200"
}

variable "capacity_properties_deployment_minimum_healthy_percent" {
  description = "capacity_properties_deployment_maximum_percent sets the minimum deployment size of the current capacity, 0% means no tasks need to be running at the moment of"
  default     = "100"
}

variable "ecs_task_definition_arn" {
  description = "ECS task definition arn"
  default = ""
}

variable "service_discovery_enabled" {
  default     = "false"
  description = "service_discovery_enabled enables service discovery"
}

variable "service_discovery_properties_namespace_id" {
  default     = ""
  description = "service_discovery_properties_namespace_id sets the service discovery namespace"
}

variable "service_discovery_properties_dns_ttl" {
  default     = "60"
  description = "service_discovery_properties_dns_ttl sets the service discovery dns ttl"
}

variable "service_discovery_properties_dns_type" {
  default     = "A"
  description = "service_discovery_properties_dns_ttl sets the service discovery dns ttl"
}

variable "service_discovery_properties_routing_policy" {
  default     = "MULTIVALUE"
  description = "The routing policy that you want to apply to all records that Route 53 creates when you register an instance and specify the service. Valid Values: MULTIVALUE, WEIGHTED"
}

variable "service_discovery_properties_healthcheck_custom_failure_threshold" {
  default     = "1"
  description = "The number of 30-second intervals that you want service discovery to wait before it changes the health status of a service instance. Maximum value of 10."
}

variable "awsvpc_subnets" {
  default     = []
  description = "AWSVPC ( FARGATE ) need subnets to reside in"
}

variable "awsvpc_security_group_ids" {
  default     = []
  description = "AWSVPC ( FARGATE ) need awsvpc_security_group_ids attached to the task"
}

variable "tags" {
  description = "A map of tags to apply to all taggable resources"
  type        = map
  default     = {}
}

variable "health_check_grace_period_seconds" {
  description = "The amount of seconds to wait before the first health check. Only relevant for load balanced apps. Default 5 minutes"
  default     = 300
}
