# =========================
# RDS
# =========================
output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "psql_command" {
  value = "psql -h ${module.rds.db_endpoint} -U ${var.db_username} -d ${var.db_name}"
}

output "rds_security_group_id" {
  value = module.rds.rds_sg_id
}

# =========================
# VPC
# =========================
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

# =========================
# ALB
# =========================
output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_target_group_arn" {
  value = module.alb.target_group_arn
}

output "alb_sg_id" {
  value = module.alb.alb_sg_id
}

# =========================
# ASG
# =========================
output "asg_name" {
  value = module.autoscaling.asg_name
}

output "asg_sg_id" {
  value = module.autoscaling.asg_sg_id
}

