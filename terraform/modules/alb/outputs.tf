output "dns_name" {
  description = "DNS del Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN del Target Group asociado al ALB"
  value       = aws_lb_target_group.this.arn
}

output "alb_sg_id" {
  description = "ID del Security Group creado para el ALB"
  value       = aws_security_group.alb.id
}

output "zone_id" {
  description = "Zone ID del ALB"
  value       = aws_lb.this.zone_id
}

