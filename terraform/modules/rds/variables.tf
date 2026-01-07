variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}




variable "vpc_id" {
  type = string
}

variable "allowed_security_group_ids" {
  type = list(string)
}
variable "project_name" {
  type = string
}
