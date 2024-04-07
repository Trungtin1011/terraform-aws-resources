module "glue_table" {
  source            = "../custom-aws-glue//modules/glue-table?ref=v1.0.0"
  table_name        = "test_glue_table"
  database_name     = "test_glue_database"
  table_description = "Glue Terraform submodule"
  table_storage_descriptor = {
    compressed = false
    columns = {
      name    = "year"
      type    = "int"
      comment = "year"
    }

    columns = {
      name    = "month"
      type    = "int"
      comment = "month"
    }

    columns = {
      name    = "day"
      type    = "int"
      comment = "day"
    }
  }

  table_partition_keys = [
    {
      name    = "year"
      type    = "int"
      comment = "year"
    },
    {
      name    = "month"
      type    = "int"
      comment = "month"
    },
    {
      name    = "day"
      type    = "int"
      comment = "day"
    }
  ]
}

output "table_id" { value = module.glue_table.table_id }
output "table_name" { value = module.glue_table.table_name }
output "table_arn" { value = module.glue_table.table_arn}