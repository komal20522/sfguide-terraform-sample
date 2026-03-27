variable "organization_name" {
  type = string
}

variable "account_name" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable "snowflake_user" {
  type    = string
  default = "TERRAFORM_SVC"
}

variable "sysadmin_role" {
  type    = string
  default = "SYSADMIN"
}

variable "useradmin_role" {
  type    = string
  default = "USERADMIN"
}

# Infra
variable "database_name" {
  type = string
}

variable "schema_name" {
  type = string
}

variable "warehouse_name" {
  type = string
}

# User
variable "role_name" {
  type = string
}

variable "user_name" {
  type = string
}

# Table
variable "table_name" {
  type = string
}

# Stage
variable "stage_name" {
  type = string
}