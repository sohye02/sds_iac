#
# Outputs
#

output "resource_prefix" {
  description = "resource_prefix"
  #  value       = random_string.random.result
  value = var.resource_prefix
}

### EKS
output "config_map_aws_auth" {
  description = "EKS : config_map_aws_auth"
  value       = module.eks.config_map_aws_auth
}

output "kubeconfig" {
  description = "EKS : kubeconfig"
  value       = module.eks.kubeconfig
}

### RDS(Mariadb)
output "mariadb_endpoint" {
  description = "The connection endpoint"
  value       = module.data.mariadb_endpoint
}

output "mariadb_user_name" {
  description = "The master username for the database"
  value       = module.data.mariadb_user_name
}

output "mariadb_user_password" {
  description = "The master password for the database"
  value       = module.data.mariadb_user_password
}

## Elasticache(Redis)
output "redis_cluster_endpoint" {
  description = "The elasticache_cluster connection endpoint url"
  value       = module.data.redis_cluster_endpoint
}


## EIP
output "eip_allocation_id" {
  description = "EIP allocated ID"
  value       = [module.vpc.public_ip[*]]
}

/*
## iam user key for emarket s3 access
output "aws_iam_user_for_s3" {
  description = "aws_iam_user_for_emarket_s3"
  value       = module.data.aws_iam_user_for_s3
}
*/
