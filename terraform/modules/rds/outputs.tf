# terraform/modules/rds/outputs.tf
output "db_endpoint" {
  description = "Endpoint del RDS"
  value       = aws_db_instance.this.endpoint
}

output "rds_security_group_ids" {
  description = "IDs de los Security Groups asociados al RDS"
  value       = aws_db_instance.this.vpc_security_group_ids
}

# Si solo querés el primer SG (porque usás uno solo), convertimos el set a lista:
output "rds_sg_id" {
  description = "ID del Security Group del RDS (primer SG)"
  value       = tolist(aws_db_instance.this.vpc_security_group_ids)[0]
}

