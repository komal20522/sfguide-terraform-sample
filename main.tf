terraform {
  required_providers {
    snowflake = {
      source  = "snowflakedb/snowflake"
      version = ">= 2.0"
    }
  }
}

# SYSADMIN
provider "snowflake" {
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.snowflake_user
  role              = var.sysadmin_role
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.private_key_path)

  preview_features_enabled = [
    "snowflake_stage_resource",
    "snowflake_file_format_resource",
    "snowflake_table_resource"
  ]
}

# USERADMIN
provider "snowflake" {
  alias             = "useradmin"
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.snowflake_user
  role              = var.useradmin_role
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.private_key_path)
  preview_features_enabled = [
    "snowflake_stage_resource",
    "snowflake_file_format_resource",
    "snowflake_table_resource"
  ]
}

# Database
resource "snowflake_database" "tf_db" {
  name = var.database_name
}

# Warehouse
resource "snowflake_warehouse" "tf_wh" {
  name           = var.warehouse_name
  warehouse_size = "SMALL"
  auto_suspend   = 60
  auto_resume    = true
}

# Schema
resource "snowflake_schema" "tf_schema" {
  name     = var.schema_name
  database = snowflake_database.tf_db.name
}