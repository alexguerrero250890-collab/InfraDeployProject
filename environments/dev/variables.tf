variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "InfraDeploy"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 in eu-north-1"
  type        = string
  default     = "ami-0b46816ffa1234887"
}

# ===============================
# ASG sizing (dev defaults)
# ===============================
variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 1

  validation {
    condition     = var.asg_min_size >= 0
    error_message = "asg_min_size must be >= 0."
  }
}

variable "asg_desired_capacity" {
  description = "Desired number of instances in the Auto Scaling Group"
  type        = number
  default     = 1

  validation {
    condition     = var.asg_desired_capacity >= 0
    error_message = "asg_desired_capacity must be >= 0."
  }
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 4

  validation {
    condition     = var.asg_max_size >= 1
    error_message = "asg_max_size must be >= 1."
  }
}

# PostgreSQL variables
variable "db_name" {
  type        = string
  description = "Nombre DB"
}

variable "db_username" {
  type        = string
  description = "Usuario admin DB"
}

variable "db_password" {
  type        = string
  description = "Password DB"
  sensitive   = true
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  type    = number
  default = 20
}

variable "db_multi_az" {
  type        = bool
  description = "Enable Multi-AZ for RDS"
  default     = false
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod."
  }
}
