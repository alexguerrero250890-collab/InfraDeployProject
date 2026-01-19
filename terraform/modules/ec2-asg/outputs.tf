output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_sg_id" {
  description = "Security Group del ASG"
  value       = aws_security_group.this.id
}

output "desired_capacity" {
  description = "Capacidad deseada del ASG"
  value       = aws_autoscaling_group.this.desired_capacity
}

output "scale_out_policy_arn" {
  description = "ARN de la policy de scale out"
  value       = aws_autoscaling_policy.scale_out.arn
}

output "scale_in_policy_arn" {
  description = "ARN de la policy de scale in"
  value       = aws_autoscaling_policy.scale_in.arn
}

