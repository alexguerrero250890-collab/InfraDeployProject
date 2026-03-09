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

    security_groups = compact(concat(
      var.allowed_security_group_ids,
      var.asg_sg_ids,
      var.bastion_sg_id == null ? [] : [var.bastion_sg_id]
    ))

    # IMPORTANT: allow same SG (needed when RDS Proxy shares the same SG with the DB)
    self = true
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

  skip_final_snapshot = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-db"
    Environment = var.environment
  }
}

# =========================
# RDS Proxy Secret (exists in your state already)
# =========================
resource "aws_secretsmanager_secret" "rds_proxy" {
  name = "${var.project_name}-${var.environment}/rds/proxy"

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-proxy"
    Environment = var.environment
  }
}

# Store credentials in the secret so RDS Proxy can use them
resource "aws_secretsmanager_secret_version" "rds_proxy" {
  secret_id = aws_secretsmanager_secret.rds_proxy.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

# =========================
# IAM Role for RDS Proxy to read the secret
# =========================
resource "aws_iam_role" "rds_proxy" {
  name = "${var.project_name}-${var.environment}-rds-proxy-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "rds.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "rds_proxy_secrets" {
  name = "${var.project_name}-${var.environment}-rds-proxy-secrets-policy"
  role = aws_iam_role.rds_proxy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadProxySecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.rds_proxy.arn
      }
    ]
  })
}

# =========================
# RDS Proxy
# =========================
resource "aws_db_proxy" "this" {
  name                   = lower("${var.project_name}-${var.environment}-rds-proxy")
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.rds_proxy.arn
  vpc_subnet_ids         = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Requires TLS; your clients must use SSL (recommended anyway)
  require_tls = true

  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.rds_proxy.arn
    iam_auth    = "DISABLED"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-rds-proxy"
    Environment = var.environment
  }

  depends_on = [aws_secretsmanager_secret_version.rds_proxy]
}

resource "aws_db_proxy_default_target_group" "this" {
  db_proxy_name = aws_db_proxy.this.name

  connection_pool_config {
    max_connections_percent      = 90
    max_idle_connections_percent = 50
    connection_borrow_timeout    = 120
  }
}

resource "aws_db_proxy_target" "this" {
  db_proxy_name          = aws_db_proxy.this.name
  target_group_name      = aws_db_proxy_default_target_group.this.name
  db_instance_identifier = aws_db_instance.this.identifier
}

