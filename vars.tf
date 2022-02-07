## Common configuration #################################
terraform {
  backend "s3" {
    bucket = "eon-terra-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
  }
  required_version = ">= 0.12"
}

variable "aws_region" {
  default = "ap-southeast-1"
  description = "AWS region"
}


resource "random_string" "random" {
  length  = 3
  special = false
  upper   = false
  number  = false
}

## Ask the resource prefix
/*
variable "resource_prefix" {
  description = "Input the resource prefix (eg. kim)"
}
*/

## EKS configuration ###################################
variable "cluster_name" {
  default = "eks-cluster"
  type    = string
}

variable "cluster_node_name" {
  default = "eks-node"
  type    = string
}


variable "node_type" {
  default = ["c5.4xlarge"]
#  default = ["t3.small"]
  type    = list(any)
}


## RDS configuration ###################################
variable "mariadb_version" {
  default = "10.5.12"
  type = string
  description = "RDS : Mariadb engine verion"
}

variable "mariadb_storage" {
  default = 10 # GB
  type = number
  description = "RDS : Mariadb Allocated storage"
}

variable "mariadb_port" {
  default = 3306
  type = number
  description = "RDS : Mariadb port"
}

variable "mariadb_name" {
  default = "KeycloakDb"
  type = string
  description = "RDS : db name for service application"
}

variable "mariadb_instance_class" {
  default = "db.m5.large"
  type = string
  description = "RDS :  Mariadb instance size"
}

variable "mariadb_master_user_name" {
  default = "admin"
  type = string
  description = "RDS : master user name"
}

variable "mariadb_master_password" { # Input value
  default = "admin12#$"
  type = string
  description = "Input the mariadb's master password (more than 8 characters)"
}



## S3 configuration ###################################
variable "s3_bucket_name" {
  default = "s3-bucket"
  type = string
  description = "S3 bucket name for service application"
}


## Elasticache(redis) ###################################
variable "redis_port" {
  default = 6379
  type = number
  description = "Elaticache : Redis port"
}

