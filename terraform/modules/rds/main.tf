resource "aws_db_subnet_group" "this" {
  name       = lower("${var.project_name}-${var.environment}-db-subnet-group")
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_security_group" "rds" {
  name   = "${var.project_name}-${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = concat(
      var.allowed_security_group_ids,
      var.asg_sg_ids,
      [var.bastion_sg_id]
    )
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier = lower("${var.project_name}-${var.environment}-db")

  engine         = "postgres"
  engine_version = "15"

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.this.name

  multi_az = var.multi_az

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret" "rds_proxy" {
  name = "${var.project_name}-${var.environment}/rds/proxy"

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-proxy"
    Environment = var.environment
  }
}

