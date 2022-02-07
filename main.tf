
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

provider "http" {}


module "vpc" {
  source          = "./vpc_module"
  aws_region      = var.aws_region
# resource_prefix = var.resource_prefix
  resource_prefix = "${random_string.random.result}"
  cluster_name    = var.cluster_name
}


module "eks" {
  source            = "./eks_module"

  resource_prefix   = "${random_string.random.result}"
  cluster_name      = var.cluster_name
  cluster_node_name = var.cluster_node_name
  node_type         = var.node_type

  vpc_id            = module.vpc.vpc_id
  subnet_id1        = module.vpc.private_subnet_id[0]
  subnet_id2        = module.vpc.private_subnet_id[1]
}


module "data" {
  source          = "./data_module"
  resource_prefix = "${random_string.random.result}"

  mariadb_version          = var.mariadb_version
  mariadb_storage          = var.mariadb_storage
  mariadb_port             = var.mariadb_port
  mariadb_name             = var.mariadb_name
  mariadb_instance_class   = var.mariadb_instance_class
  mariadb_master_user_name = var.mariadb_master_user_name
  mariadb_master_password  = var.mariadb_master_password
  s3_bucket_name           = var.s3_bucket_name
  redis_port               = var.redis_port

  vpc_id          = module.vpc.vpc_id
  subnet_id1      = module.vpc.private_subnet_id[0]
  subnet_id2      = module.vpc.private_subnet_id[1]
}

