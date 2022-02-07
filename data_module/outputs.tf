#
# Outputs
#

locals {
  mariadb_endpoint   = element(concat(aws_db_instance.terra.*.endpoint, aws_db_instance.terra.*.endpoint, [""]), 0)
  mariadb_user_name  = element(concat(aws_db_instance.terra.*.username, aws_db_instance.terra.*.username, [""]), 0)
}

output "mariadb_endpoint" {
  description = "The connection endpoint"
  value       = local.mariadb_endpoint
}

output "mariadb_user_name" {
  description = "The master username for the database"
  value       = local.mariadb_user_name
}

output "mariadb_user_password" {
  description = "The master password for the database"
  value       = "${random_string.password.result}"
}


## elasticache(Redis)
locals {
  redis_cluster_endpoint  = element(concat(aws_elasticache_cluster.terra.*.cache_nodes, aws_elasticache_cluster.terra.*.cache_nodes, [""]), 0)
}

output "redis_cluster_endpoint" {
  description = "The elasticache_cluster connection endpoint url"
  value       = local.redis_cluster_endpoint
}
