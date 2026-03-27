# Create Role
resource "snowflake_account_role" "tf_role" {
  provider = snowflake.useradmin
  name     = var.role_name
  comment  = "Terraform role"
}

# Grant role to SYSADMIN
resource "snowflake_grant_account_role" "grant_tf_role_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.tf_role.name
  parent_role_name = var.sysadmin_role
}

# Generate key
resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create User
resource "snowflake_user" "tf_user" {
  provider          = snowflake.useradmin
  name              = var.user_name
  default_warehouse = snowflake_warehouse.tf_warehouse.name
  default_role      = snowflake_account_role.tf_role.name
  default_namespace = "${snowflake_database.tf_db.name}.${snowflake_schema.tf_schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

# Grant Role to User
resource "snowflake_grant_account_role" "grant_role_to_user" {
  provider  = snowflake.useradmin
  role_name = snowflake_account_role.tf_role.name
  user_name = snowflake_user.tf_user.name
}

# DB Usage
resource "snowflake_grant_privileges_to_account_role" "db_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.tf_role.name

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.tf_db.name
  }
}

# Schema Usage
resource "snowflake_grant_privileges_to_account_role" "schema_usage" {
  provider          = snowflake.useradmin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.tf_role.name

  on_schema {
    schema_name = snowflake_schema.tf_schema.fully_qualified_name
  }
}

# All Tables
resource "snowflake_grant_privileges_to_account_role" "all_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.tf_role.name

  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.tf_schema.fully_qualified_name
    }
  }
}

# Future Tables
resource "snowflake_grant_privileges_to_account_role" "future_tables" {
  provider          = snowflake.useradmin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.tf_role.name

  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_schema          = snowflake_schema.tf_schema.fully_qualified_name
    }
  }
}