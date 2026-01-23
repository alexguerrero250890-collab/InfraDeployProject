variable "project_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
}

