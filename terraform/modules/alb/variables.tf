variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el ALB"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets públicas para el ALB"
  type        = list(string)
}

