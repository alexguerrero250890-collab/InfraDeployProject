variable "project_name" {
  type = string
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
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
  default     = 1

  validation {
    condition     = var.min_size >= 0
    error_message = "min_size must be >= 0."
  }
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 1

  validation {
    condition     = var.desired_capacity >= 0
    error_message = "desired_capacity must be >= 0."
  }
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 4

  validation {
    condition     = var.max_size >= 1
    error_message = "max_size must be >= 1."
  }
}
