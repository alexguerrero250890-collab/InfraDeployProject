resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "Security Group for EC2"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.alb_sg_id != null ? [var.alb_sg_id] : []
    content {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-ec2-sg"
    Environment = var.environment
  }
}

