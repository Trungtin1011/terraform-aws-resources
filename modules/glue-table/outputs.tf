#############################
# Catalog Table Outputs 
#############################
output "table_id" {
  description = "Glue catalog table ID"
  value       = try(aws_glue_catalog_table.this.id, "")
}

output "table_name" {
  description = "Glue catalog table name"
  value       = try(aws_glue_catalog_table.this.name, "")
}

output "table_arn" {
  description = "Glue catalog table ARN"
  value       = try(aws_glue_catalog_table.this.arn, "")
}