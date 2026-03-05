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
# VPC
# ===============================
module "vpc" {
  source       = "../../terraform/modules/vpc"
  project_name = var.project_name
  environment  = var.environment

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

  availability_zones = ["eu-north-1a", "eu-north-1b"]
}

# ===============================
# ROUTE53 (usamos zona existente)
# ===============================
module "route53" {
  source       = "../../terraform/modules/route53"
  project_name = var.project_name
  environment  = "dev"
  domain_name  = "infraproj.com"
}

# ===============================
# ACM (certificado HTTPS)
# ===============================
module "acm" {
  source         = "../../terraform/modules/acm"
  project_name   = var.project_name
  environment    = "dev"
  domain_name    = "dev.infraproj.com"
  hosted_zone_id = module.route53.zone_id
}

# ===============================
# ALB (HTTP → HTTPS, HTTPS con ACM)
# ===============================
module "alb" {
  source              = "../../terraform/modules/alb"
  project_name        = var.project_name
  environment         = var.environment
  subnet_ids          = module.vpc.public_subnet_ids
  vpc_id              = module.vpc.vpc_id
  acm_certificate_arn = module.acm.certificate_arn
}

# ===============================
# EC2 SG (para ASG)
# ===============================
module "ec2" {
  source       = "../../terraform/modules/ec2"
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  alb_sg_id    = module.alb.alb_sg_id
}

# ===============================
# ASG (sin SSH, con SSM)
# ===============================
module "autoscaling" {
  source        = "../../terraform/modules/ec2-asg"
  project_name  = var.project_name
  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnet_ids    = module.vpc.public_subnet_ids
  vpc_id        = module.vpc.vpc_id

  alb_target_group_arn = module.alb.target_group_arn
  alb_sg_id            = module.alb.alb_sg_id

  min_size         = 1
  desired_capacity = 1
  max_size         = 4
}

# ===============================
# RDS en la misma VPC y subnets privadas
# ===============================
module "rds" {
  source = "../../terraform/modules/rds"

  project_name = var.project_name
  environment  = var.environment

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

  asg_sg_ids    = [module.autoscaling.asg_sg_id]
  bastion_sg_id = module.autoscaling.asg_sg_id
}

# ===============================
# Route53 record para ALB
# ===============================
resource "aws_route53_record" "alb_dev" {
  zone_id = module.route53.zone_id
  name    = "dev"
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}

