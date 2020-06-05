output "cert_arn" {
  value = concat(aws_acm_certificate.cert[*].arn, [""])[0]
}
