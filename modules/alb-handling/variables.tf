# The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused. The range is 0-3600 seconds. 
variable "deregistration_delay" {}

# unhealthy_threshold defines the threashold for the target_group after which a service is seen as unhealthy.
variable "unhealthy_threshold" {}

variable "healthy_threshold" {}

variable "cluster_name" {
  default = ""
}

variable "name" {
  default = ""
}

# lb_arn sets the arn of the ALB
variable "lb_arn" {
  default = ""
}

# The VPC ID of the VPC where the ALB is residing
variable "lb_vpc_id" {
  default = ""
}

# cert_arn for https listener
variable "cert_arn" {
  default = ""
}

# target_type is the alb_target_group target, in case of EC2 it's instance, in case of FARGATE it's IP
variable "target_type" {
  default = ""
}

# target_group_port sets the port of the target group
variable "target_group_port" {
  default = "80"
}

variable "health_uri" {
  default = ""
}

# port for the health check. Defaults to traffic-port
variable "health_port" {
  default = "traffic-port"
}

# The expected HTTP status for the health check to be marked healthy
# You can specify multiple values (for example, "200,202") or a range of values (for example, "200-299")
variable "health_matcher" {
  default = "200"
}

# Route53 Zone to add subdomain to. 
# Example:
# 
# zone-id domain = prod.example.com
# 
# Final created subdomain will be [route53_name].prod.example.com
# 
variable "route53_zone_id" {
  default = ""
}

variable "route53_name" {
  default = ""
}

# Small Lookup map to validate route53_record_type
variable "allowed_record_types" {
  default = {
    ALIAS = "ALIAS"
    CNAME = "CNAME"
    NONE  = "NONE"
  }
}

# route53_record_type, one of the allowed values of the map allowed_record_types
variable "route53_record_type" {}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map
  default     = {}
}

locals {
  name_map = {
    "Name" = "${var.name}"
  }

  tags = "${merge(var.tags, local.name_map)}"
}
