variable "db_name" {
  type        = string
  description = "Nombre de la base de datos"
}

variable "db_username" {
  type        = string
  description = "Usuario maestro de la base de datos"
}

variable "db_password" {
  type        = string
  description = "Password del usuario maestro"
  sensitive   = true
}

variable "instance_class" {
  type        = string
  description = "Tipo de instancia RDS"
}

variable "allocated_storage" {
  type        = number
  description = "Almacenamiento asignado (GB) para RDS"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Lista de subnets donde se desplegará RDS"
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC donde estará RDS"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "Lista de Security Groups de EC2 que pueden conectarse al RDS"
  default     = []
}

variable "asg_sg_ids" {
  type        = list(string)
  description = "Lista de Security Groups del ASG que pueden conectarse al RDS"
  default     = []
}

variable "bastion_sg_id" {
  type        = string
  description = "Security Group de la EC2 bastión que puede conectarse al RDS"
  default     = null
}

variable "project_name" {
  type        = string
  description = "Nombre del proyecto para tags y nombres de recursos"
}

variable "multi_az" {
  type        = bool
  description = "Habilitar RDS Multi-AZ"
  default     = true
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

