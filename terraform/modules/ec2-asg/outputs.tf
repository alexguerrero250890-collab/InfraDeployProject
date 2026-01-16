output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "launch_template_id" {
  description = "ID del Launch Template asociado al ASG"
  value       = aws_launch_template.this.id
}

output "asg_sg_id" {
  description = "Security Group del ASG"
  value       = aws_security_group.this.id
}

output "desired_capacity" {
  description = "Capacidad deseada del Auto Scaling Group"
  value       = aws_autoscaling_group.this.desired_capacity
}

