# ========================
# Configuración global
# ========================
aws_region   = "eu-north-1"
environment  = "prod"
project_name = "InfraDeploy-Prod"

# ========================
# EC2
# ========================
instance_type = "t3.micro"
ami_id        = "ami-0b46816ffa1234887"

# ========================
# RDS PostgreSQL
# ========================
db_name              = "infradeployprod"
db_username          = "postgres"
db_password          = "SuperPassword123!"
db_instance_class    = "db.t3.small"
db_allocated_storage = 50
db_multi_az          = true

