resource "snowflake_table" "tf_table" {
  name     = var.table_name
  database = snowflake_database.tf_db.name
  schema   = snowflake_schema.tf_schema.name

  column {
    name = "ID"
    type = "NUMBER"
  }

  column {
    name = "NAME"
    type = "STRING"
  }

  column {
    name = "CREATED_AT"
    type = "TIMESTAMP_NTZ"
  }
}