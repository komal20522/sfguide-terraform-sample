resource "snowflake_account_role" "tf_role" {
  provider = snowflake.useradmin
  name     = var.role_name
}

resource "snowflake_grant_account_role" "grant_to_sysadmin" {
  provider         = snowflake.useradmin
  role_name        = snowflake_account_role.tf_role.name
  parent_role_name = var.sysadmin_role
}

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "tf_user" {
  provider          = snowflake.useradmin
  name              = var.user_name
  default_role      = snowflake_account_role.tf_role.name
  default_warehouse = snowflake_warehouse.tf_wh.name
  default_namespace = "${snowflake_database.tf_db.name}.${snowflake_schema.tf_schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "snowflake_grant_account_role" "grant_role_to_user" {
  provider  = snowflake.useradmin
  role_name = snowflake_account_role.tf_role.name
  user_name = snowflake_user.tf_user.name
}