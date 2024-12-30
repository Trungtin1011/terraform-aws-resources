#############################
# Partition Outputs 
#############################
# output "partition_id" {
#   description = "Glue catalog table ID"
#   value       = [for name in keys(aws_glue_partition.this) : aws_glue_partition.this[name].id]
# }

output "partition_id" {
  description = "Glue catalog table ID"
  value       = aws_glue_partition.this[*].id
}

output "partition_creation_time" {
  description = "The time at which the partition was created."
  value       = aws_glue_partition.this[*].creation_time
}

output "partition_last_analyzed_time" {
  description = "The last time at which column statistics were computed for this partition."
  value       = aws_glue_partition.this[*].last_analyzed_time
}

output "partition_last_accessed_time" {
  description = "The last time at which the partition was accessed."
  value       = aws_glue_partition.this[*].last_accessed_time
}


#############################
# Partition Index Outputs 
#############################
output "partition_index_id" {
  description = "Partition index ID"
  value       = aws_glue_partition_index.this[*].id
}

output "partition_indexes" {
  description = "Partition indexes list"
  value       = aws_glue_partition_index.this[*].partition_index
}

# output "all_partition_index_status" {
#   value = [for name in keys(aws_glue_partition_index.this) : [for item in aws_glue_partition_index.this[name].partition_index : item.index_status]]
# }