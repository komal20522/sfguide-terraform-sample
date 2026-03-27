variable "organization_name" {
  description = "Snowflake organization name"
  type        = string
}

variable "account_name" {
  description = "Snowflake account name"
  type        = string
}

variable "private_key_path" {
  description = "Path to private key"
  type        = string
}

variable "snowflake_user" {
  description = "Terraform service user"
  type        = string
  default     = "TERRAFORM_SVC"
}

variable "sysadmin_role" {
  description = "SYSADMIN role"
  type        = string
  default     = "SYSADMIN"
}

variable "useradmin_role" {
  description = "USERADMIN role"
  type        = string
  default     = "USERADMIN"
}

# Infra
variable "database_name" {
  type    = string
}

variable "schema_name" {
  type    = string
}

variable "warehouse_name" {
  type    = string
}

# User / Role
variable "role_name" {
  type    = string
}

variable "user_name" {
  type    = string
}