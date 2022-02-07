#
# Data Store
#  * S3
#  * RDS (MariaDB 10.5.12)
#  * Elasticache (Redis 6.x)
#

## create s3 ######################################################
resource "aws_s3_bucket" "terra" {
  bucket = "${var.resource_prefix}-${var.s3_bucket_name}"
  acl    = "private"

  tags = {
    Name        = "${var.resource_prefix}-terraform-s3"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "terra" {
  bucket = aws_s3_bucket.terra.id
  ignore_public_acls = true
}


## creat rds #####################################################
resource "random_string" "password" {
  length  = 10
  special = true
  override_special = "/@"
}

resource "aws_db_subnet_group" "terra" {
  name        = "${var.resource_prefix}-terraform-rds-subnet-group"
  description = "Terraform example RDS subnet group"
  subnet_ids = [var.subnet_id1, var.subnet_id2]
  tags = {
    Name = "aws db subnet group via terraform"
  }
}

resource "aws_db_instance" "terra" {
  identifier             = "${var.resource_prefix}-keycloackdb"
  allocated_storage      = 10
  engine                 = "mariadb"
  engine_version         = "${var.mariadb_version}"
  instance_class         = "${var.mariadb_instance_class}"
  name                   = "${var.mariadb_name}"
  username               = "${var.mariadb_master_user_name}"
  password               = random_string.password.result
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.terra.id}"]
  db_subnet_group_name   = aws_db_subnet_group.terra.id
  parameter_group_name   = aws_db_parameter_group.terra.name
}


resource "aws_db_parameter_group" "terra" {
  name    = "terraparameter"
  family  = "mariadb10.5"
  parameter {
    name  = "max_connections"
    value = "1000"
  }
}


resource "aws_security_group" "terra" {
  name        = "${var.resource_prefix}-terraform_rds_sg"
  description = "Terraform RDS MariaDB sg"
  vpc_id      = var.vpc_id
  
  ingress {
    from_port   = "${var.mariadb_port}"
    to_port     = "${var.mariadb_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


## create elasticache(redis) ##################################
resource "aws_elasticache_cluster" "terra" {
  cluster_id           = "${var.resource_prefix}-redis-cluster"
  engine               = "redis"
  node_type            = "cache.m5.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  engine_version       = "6.x"
  port                 = 6379
  security_group_ids = ["${aws_security_group.redis_sg.id}"]
  subnet_group_name = aws_elasticache_subnet_group.terra.id

}


resource "aws_elasticache_subnet_group" "terra" {
  name       = "${var.resource_prefix}-redis-subnet-group"
  subnet_ids  = [var.subnet_id1, var.subnet_id2]
}

resource "aws_security_group" "redis_sg" {
  name = "${var.resource_prefix}-redis-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "${var.redis_port}"
    to_port     = "${var.redis_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



