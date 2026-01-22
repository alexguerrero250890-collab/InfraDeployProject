variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "environment" {
  description = "Entorno (dev, prod, etc)"
  type        = string
}

variable "domain_name" {
  description = "Dominio base existente en Route53"
  type        = string
}

