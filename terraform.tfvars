# ========================
# Configuración global
# ========================
aws_region   = "eu-north-1"
project_name = "InfraDeploy-Dev"

# ========================
# EC2
# ========================
instance_type = "t3.micro"
ami_id        = "ami-0b46816ffa1234887"

# ========================
# RDS PostgreSQL
# ========================
db_name              = "infradeploydev"
db_username          = "postgres"
db_password          = "SuperPassword123!"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 20
db_multi_az = true
