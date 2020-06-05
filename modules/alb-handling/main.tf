data "aws_lb" "main" {
  count = (var.lb_arn != "" && var.route53_record_type != "NONE") ? 1 : 0
  arn   = var.lb_arn
}

locals {
  # Validate the record type by looking up the map with valid record types
  route53_record_type = lookup(var.allowed_record_types, var.route53_record_type)

  # We limit the target group name to a length of 32
  tg_name = format("%.32s", format("%v-%v", var.cluster_name, var.name))

  cert_arns = var.cert_arn != "" ? list(var.cert_arn) : []
}

## Route53 DNS Record
resource "aws_route53_record" "record" {
  count = (var.lb_arn != "" && var.route53_record_type == "CNAME") ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.route53_name
  type    = "CNAME"
  ttl     = "300"
  records = [data.aws_lb.main[count.index].dns_name]
}

## Route53 DNS Record
resource "aws_route53_record" "record_alias_a" {
  count   = (var.lb_arn != "" && var.route53_record_type == "ALIAS") ? 1 : 0
  zone_id = var.route53_zone_id
  name    = var.route53_name
  type    = "A"

  alias {
    name                   = data.aws_lb.main[count.index].dns_name
    zone_id                = data.aws_lb.main[count.index].zone_id
    evaluate_target_health = false
  }
}

resource "aws_alb_target_group" "service" {
  count                = (var.lb_arn != "") ? 1 : 0
  name                 = local.tg_name
  port                 = var.target_group_port
  protocol             = "HTTP"
  vpc_id               = var.lb_vpc_id
  target_type          = var.target_type
  deregistration_delay = var.deregistration_delay

  health_check {
    matcher             = var.health_matcher
    path                = var.health_uri
    unhealthy_threshold = var.unhealthy_threshold
    healthy_threshold   = var.healthy_threshold
    port                = var.health_port
  }

  tags = local.tags
}

//resource "aws_alb_listener" "front_end_https" {
//  count             = (var.cert_arn != "") ? 1 : 0
//  load_balancer_arn = var.lb_arn
//  port              = 443
//  protocol          = "HTTPS"
//  certificate_arn   = var.cert_arn
//  ssl_policy        = "ELBSecurityPolicy-2015-05"
//
//  default_action {
//    target_group_arn = aws_alb_target_group.service[count.index].id
//    type             = "forward"
//  }
//}

resource "aws_alb_listener" "front_end_https" {
    for_each = toset(local.cert_arns)
    load_balancer_arn = var.lb_arn
    port              = 443
    protocol          = "HTTPS"
    certificate_arn   = each.key
    ssl_policy        = "ELBSecurityPolicy-2015-05"

    default_action {
      target_group_arn = aws_alb_target_group.service[0].id
      type             = "forward"
    }
}
