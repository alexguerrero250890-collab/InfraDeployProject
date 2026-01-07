variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR de la subnet pública"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDRs de las subnets privadas"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

