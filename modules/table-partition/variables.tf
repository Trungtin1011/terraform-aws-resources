#############################
# Glue Partition Variables 
#############################
variable "create_partition" {
  type        = bool
  description = "Decide whether to create AWS Glue Partition"
  default     = false
}

variable "partitions" {
  type        = any
  description = "List of Partition to create"
  default     = []
}


#############################
# Glue Partition Index Variables 
#############################
variable "create_partition_index" {
  type        = bool
  description = "Decide whether to create AWS Glue Partition Index"
  default     = false
}

variable "indexes" {
  type        = any
  description = "List of Partition Index to create"
  default     = []
}