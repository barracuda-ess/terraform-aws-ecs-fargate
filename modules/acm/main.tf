resource "aws_acm_certificate" "cert" {
  count                     = var.https_enabled == 1 ? 1 : 0
  domain_name               = var.cert_domain
  validation_method         = "DNS"
  subject_alternative_names = var.cert_sans

  lifecycle {
    create_before_destroy = true
  }

  tags = local.tags
}

resource "aws_route53_record" "cert_validation" {
  count   = var.https_enabled == 1 ? 1 : 0
  name    = aws_acm_certificate.cert[0].domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert[0].domain_validation_options.0.resource_record_type
  zone_id = var.r53_zone_id
  records = [aws_acm_certificate.cert[0].domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count           = var.https_enabled == 1 ? 1 : 0
  certificate_arn = aws_acm_certificate.cert[0].arn

  validation_record_fqdns = [
    concat(aws_route53_record.cert_validation[*].fqdn, [""])[0]
  ]
}
