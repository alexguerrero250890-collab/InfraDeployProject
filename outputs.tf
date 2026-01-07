output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ssh_command" {
  value = "ssh -i KP.pem ec2-user@${module.ec2.public_ip}"
}

output "psql_command" {
  value = "psql -h ${module.rds.db_endpoint} -U ${var.db_username} -d ${var.db_name}"
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "rds_security_group_id" {
  value = module.rds.rds_sg_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_id
}

