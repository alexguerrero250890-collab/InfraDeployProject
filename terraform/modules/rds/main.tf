resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnet-group"
  subnet_ids = var.subnet_ids  # SOLO subnets privadas

  tags = {
    Name = "${var.db_name}-subnet-group"
  }

  lifecycle {
    ignore_changes = [
      subnet_ids
    ]
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow PostgreSQL from EC2, ASG and Bastion"
  vpc_id      = var.vpc_id  # MISMA VPC que EC2

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = concat(
      var.allowed_security_group_ids,
      var.asg_sg_ids,
      [var.bastion_sg_id]
    )
    description = "Allow Postgres from EC2, ASG and Bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "this" {
  identifier = lower(replace(var.db_name, "_", "-"))

  engine         = "postgres"
  engine_version = "15"

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  publicly_accessible     = false
  multi_az                = var.multi_az
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:05:00-sun:06:00"

  skip_final_snapshot = true
  deletion_protection = false

  lifecycle {
    ignore_changes = [
      endpoint,
      status
    ]
  }
}

