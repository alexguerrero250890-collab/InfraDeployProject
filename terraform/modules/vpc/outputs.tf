output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID de la subnet pública"
  value       = aws_subnet.public.id
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = [for s in aws_subnet.private : s.id]
}

output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "ID de la tabla de rutas pública"
  value       = aws_route_table.public.id
}

