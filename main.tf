terraform {
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}

# SYSADMIN Provider (Infra)
provider "snowflake" {
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.snowflake_user
  role              = var.sysadmin_role
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.private_key_path)
}

# USERADMIN Provider (Users/Roles)
provider "snowflake" {
  alias             = "useradmin"
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.snowflake_user
  role              = var.useradmin_role
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.private_key_path)
}

# Database
resource "snowflake_database" "tf_db" {
  name         = var.database_name
  is_transient = false
}

# Warehouse
resource "snowflake_warehouse" "tf_warehouse" {
  name                      = var.warehouse_name
  warehouse_type            = "STANDARD"
  warehouse_size            = "SMALL"
  max_cluster_count         = 1
  min_cluster_count         = 1
  auto_suspend              = 60
  auto_resume               = true
  enable_query_acceleration = false
  initially_suspended       = true
}

# Schema
resource "snowflake_schema" "tf_schema" {
  name                = var.schema_name
  database            = snowflake_database.tf_db.name
  with_managed_access = false
}