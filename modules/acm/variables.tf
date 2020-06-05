variable "https_enabled" {
  default = 0
}

variable "cert_domain" {}

variable "cert_sans" {}

variable "r53_zone_id" {}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map
  default     = {}
}

locals {
  name_map = {
    "Name" = var.cert_domain
  }

  tags = "${merge(var.tags, local.name_map)}"
}

