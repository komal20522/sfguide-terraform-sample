resource "snowflake_stage" "tf_stage" {
  name     = var.stage_name
  database = snowflake_database.tf_db.name
  schema   = snowflake_schema.tf_schema.name
}