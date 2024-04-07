#############################
# Catalog Table Variables 
#############################
variable "database_name" {
  type        = string
  description = "Name of the metadata database where the table metadata resides."
}

variable "table_name" {
  type        = string
  description = "Name of the table."
  default     = null
}

variable "table_description" {
  type        = string
  description = "Description of the table."
  default     = null
}

variable "table_catalog_id" {
  type        = string
  description = "ID of the Glue Catalog and database to create the table in. If omitted, this defaults to the AWS Account ID plus the database name."
  default     = null
}

variable "table_owner" {
  type        = string
  description = "Owner of the table."
  default     = null
}

variable "table_parameters" {
  type        = map(string)
  description = "Properties associated with this table, as a map of key-value pairs."
  default     = null
}

variable "table_partition_index" {
  type        = any
  description = "(Optional) List of maximum of 3 partition indexes."
  default     = []
}

variable "table_partition_keys" {
  type        = any
  description = "(Optional) A list of columns by which the table is partitioned. Only primitive types are supported as partition keys."
  default     = []
}

variable "table_retention" {
  type        = number
  description = "Retention time for the table."
  default     = null
}

variable "table_type" {
  type        = string
  description = "Type of this table (`EXTERNAL_TABLE`, `VIRTUAL_VIEW`, etc.). While optional, some Athena DDL queries such as `ALTER TABLE` and `SHOW CREATE TABLE` will fail if this argument is empty."
  default     = null
}

variable "target_table" {
  type        = any
  description = "Configuration block of a target table for resource linking."
  default     = null
}

variable "table_view_expanded_text" {
  type        = string
  description = "If the table is a view, the expanded text of the view; otherwise null."
  default     = null
}

variable "table_view_original_text" {
  type        = string
  description = "If the table is a view, the original text of the view; otherwise null."
  default     = null
}

variable "table_storage_descriptor" {
  type        = any
  description = "Configuration block for information about the physical storage of this table."
  default     = null
}

variable "open_table_format_input" {
  type        = any
  description = "(Optional) Configuration block for open table formats"
  default     = null
}