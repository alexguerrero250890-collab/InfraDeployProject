terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-infradeploy"
    key            = "dev/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

# ===============================
# VPC Module
# ===============================
module "vpc" {
  source       = "./terraform/modules/vpc"
  project_name = var.project_name

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  availability_zones = ["eu-north-1a", "eu-north-1b"]
}

# ===============================
# Security Group Module
# ===============================
module "security_group" {
  source       = "./terraform/modules/security_group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

# ===============================
# EC2 Module (solo SG para ASG)
# ===============================
module "ec2" {
  source       = "./terraform/modules/ec2"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  alb_sg_id    = module.alb.alb_sg_id
}

# ===============================
# RDS Module
# ===============================
module "rds" {
  source = "./terraform/modules/rds"

  project_name = var.project_name

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage

  subnet_ids = module.vpc.private_subnet_ids
  vpc_id     = module.vpc.vpc_id

  allowed_security_group_ids = [
    module.ec2.ec2_sg_id
  ]
}

# ===============================
# ALB Module
# ===============================
module "alb" {
  source       = "./terraform/modules/alb"
  project_name = var.project_name
  subnet_ids   = module.vpc.public_subnet_ids
  vpc_id       = module.vpc.vpc_id
}

# ===============================
# ASG Module
# ===============================
module "autoscaling" {
  source               = "./terraform/modules/ec2-asg"
  project_name         = var.project_name
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  key_name             = "KP"
  subnet_ids           = module.vpc.public_subnet_ids
  vpc_id               = module.vpc.vpc_id

  alb_target_group_arn = module.alb.target_group_arn
  alb_sg_id            = module.alb.alb_sg_id
}

