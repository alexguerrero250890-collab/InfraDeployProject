output "asg_name" {
  description = "Nombre del Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "asg_sg_id" {
  description = "Security Group del ASG"
  value       = aws_security_group.this.id
}

output "instance_profile_name" {
  description = "Instance Profile usado por las EC2"
  value       = aws_iam_instance_profile.this.name
}

