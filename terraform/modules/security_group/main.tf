resource "aws_security_group" "this" {
  name        = "${var.project_name}-sg"
  description = "Security group for Dev environment"
  vpc_id      = var.vpc_id

  # SSH desde cualquier lugar
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP desde cualquier lugar
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Acceso a PostgreSQL desde las instancias del ASG
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.asg_sg_id] # <-- Aquí ponemos el SG de tu ASG
  }

  # Todo el tráfico de salida permitido
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

