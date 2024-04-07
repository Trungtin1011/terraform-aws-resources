module "glue_partition" {
  source = "../custom-aws-glue//modules/table-partition?ref=v1.0.0"

  create_partition = true
  partitions = [
    {
      database_name    = "test_glue_database"
      table_name       = "${module.glue_table.table_name}"
      partition_values = ["2024", "04", "04"]
    },
    {
      database_name    = "test_glue_database"
      table_name       = "${module.glue_table.table_name}"
      partition_values = ["2025", "06", "05"]
    }
  ]

  create_partition_index = true
  indexes = [
    {
      database_name = "test_glue_database"
      table_name    = "${module.glue_table.table_name}"
      partition_index = {
        index_name = "separate_year_idx"
        keys       = ["year"]
      }
    },
    {
      database_name = "test_glue_database"
      table_name    = "${module.glue_table.table_name}"
      partition_index = {
        index_name = "separate_month_idx"
        keys       = ["month"]
      }
    },
    {
      database_name = "test_glue_database"
      table_name    = "${module.glue_table.table_name}"
      partition_index = {
        index_name = "separate_day_idx"
        keys       = ["day"]
      }
    }
  ]
}

output "glue_partition_id" { value = module.glue_partition.partition_id }
output "partition_creation_time" { value = module.glue_partition.partition_creation_time }
output "partition_last_analyzed_time" { value = module.glue_partition.partition_last_analyzed_time }
output "partition_last_accessed_time" { value = module.glue_partition.partition_last_accessed_time }
output "partition_index_id" { value = module.glue_partition.partition_index_id }
output "partition_indexes" { value = module.glue_partition.partition_indexes }