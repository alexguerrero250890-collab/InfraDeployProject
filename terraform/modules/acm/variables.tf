variable "project_name" {
  type        = string
  description = "Nombre del proyecto"
}

variable "environment" {
  type        = string
  description = "Entorno (dev, prod, etc)"
}

variable "domain_name" {
  type        = string
  description = "Dominio para el certificado ACM"
}

variable "hosted_zone_id" {
  type        = string
  description = "ID de la Hosted Zone existente en Route53"
}

