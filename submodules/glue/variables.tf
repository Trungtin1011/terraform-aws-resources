#############################
# Glue Resource Policy Variables
#############################
variable "enable_hybrid_resource_policy" {
  type        = string
  description = "(Optional, 'TRUE' or 'FALSE') Use both aws_glue_resource_policy and AWS Lake Formation resource policies to determine access permissions"
  default     = null
}

variable "resource_policy" {
  type        = string
  description = "(Required) The policy to be applied to the aws glue data catalog."
  default     = null
}


#############################
# Glue Catalog Encryption Variables
#############################
variable "enable_catalog_encryption" {
  type        = bool
  description = "(Optional) Whether to enable Glue Data Catalog Encryption Settings"
  default     = false
}

variable "catalog_id" {
  type        = string
  description = "(Optional) The ID of the Data Catalog to set the security configuration for. If none is provided, the AWS account ID is used by default."
  default     = null
}

variable "encrypt_connection" {
  type        = bool
  description = "(Required when **enable_catalog_encryption** == true) When set to true, passwords remain encrypted in the responses of GetConnection and GetConnections. This encryption takes effect independently of the catalog encryption."
  default     = false
}

variable "connection_encryption_key" {
  type        = string
  description = "(Optional) A KMS key ARN that is used to encrypt the connection password. If connection password protection is enabled, the caller of CreateConnection and UpdateConnection needs at least kms:Encrypt permission on the specified AWS KMS key, to encrypt passwords before storing them in the Data Catalog"
  default     = null
}

variable "encryption_at_rest_mode" {
  type        = string
  description = "(Required when **enable_catalog_encryption** == true) The encryption-at-rest mode for encrypting Data Catalog data. Valid values are DISABLED, SSE-KMS, SSE-KMS-WITH-SERVICE-ROLE."
  default     = "DISABLED"
}

variable "encryption_at_rest_role" {
  type        = string
  description = "(Optional) The ARN of the AWS IAM role used for accessing encrypted Data Catalog data."
  default     = null
}

variable "encryption_at_rest_key" {
  type        = string
  description = "(Optional) The ARN of the AWS KMS key to use for encryption at rest."
  default     = null
}


#############################
# Glue Catalog Security Variables
#############################
variable "enable_security_configuration" {
  type        = bool
  description = "(Optional) Whether to enable Glue Data Catalog Security Configuration"
  default     = false
}

variable "security_configuration_name" {
  type        = string
  description = "(Required when **enable_security_configuration** == true) Name of the security configuration."
  default     = null
}

variable "cloudwatch_encryption_mode" {
  type        = string
  description = "(Required when **enable_security_configuration** == true) A block contains encryption configuration for CloudWatch. Valid values are DISABLED, SSE-KMS"
  default     = "DISABLED"
}

variable "cloudwatch_encryption_key" {
  type        = string
  description = "(Optional) ARN of the KMS key to be used to encrypt the data. (SSE-KMS mode)"
  default     = null
}

variable "bookmarks_encryption_mode" {
  type        = string
  description = "(Required when **enable_security_configuration** == true) A block contains encryption configuration for job bookmarks. Valid values are DISABLED, CSE-KMS"
  default     = "DISABLED"
}

variable "bookmarks_encryption_key" {
  type        = string
  description = "(Optional) ARN of the KMS key to be used to encrypt the data. (CSE-KMS mode)"
  default     = null
}

variable "s3_encryption_mode" {
  type        = string
  description = "(Required when **enable_security_configuration** == true) A block contains encryption configuration for S3. Valid values are DISABLED, SSE-KMS, SSE-S3"
  default     = "DISABLED"
}

variable "s3_encryption_key" {
  type        = string
  description = "(Optional) ARN of the KMS key to be used to encrypt the data. (SSE-KMS and SSE-S3 mode)"
  default     = null
}


#############################
# Catalog Database & Registry Variables
#############################
variable "database_name" {
  type        = string
  description = "(Required) Glue catalog database name. The acceptable characters are lowercase letters, numbers, and the underscore character."
  default     = null
}

variable "database_description" {
  type        = string
  description = "Glue catalog database description."
  default     = null
}

variable "create_table_default_permission" {
  type        = any
  description = "Creates a set of default permissions on the table for principals."
  default     = null
}

variable "database_location_uri" {
  type        = string
  description = "Location of the database (for example, an HDFS path)."
  default     = null
}

variable "database_parameters" {
  type        = map(string)
  description = "Map of key-value pairs that define parameters and properties of the database."
  default     = null
}

variable "federated_database" {
  type        = any
  description = "(Optional) Configuration block that references an entity outside the AWS Glue Data Catalog"
  default     = null
}

variable "target_database" {
  type        = any
  description = "Configuration block for a target database for resource linking."
  default     = null
}

#############################
# Glue Connection Variables
#############################
variable "create_connection" {
  type        = bool
  description = "Whether to create Glue Connection"
  default     = false
}

variable "connections" {
  description = "Map of objects that define the AWS Glue Connection(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Crawler Variables
#############################
variable "create_crawler" {
  type        = bool
  description = "Whether to create Glue Crawler"
  default     = false
}

variable "crawlers" {
  description = "Map of objects that define the AWS Glue Crawler(s) to be created."
  type        = any
  default     = []
}

#############################
# Glue Classifier Variables
#############################
variable "create_custom_classifier" {
  type        = bool
  description = "Whether to create Glue Custom Classifier"
  default     = false
}

variable "custom_classifiers" {
  description = "Map of objects that define the AWS Glue Classifier(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Workflow Variables
#############################
variable "create_workflow" {
  type        = bool
  description = "Whether to create Glue Crawler"
  default     = false
}

variable "workflows" {
  description = "Map of objects that define the AWS Glue Workflow(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Trigger Variables
#############################
variable "create_trigger" {
  type        = bool
  description = "Whether to create Glue Trigger"
  default     = false
}

variable "triggers" {
  description = "Map of objects that define the AWS Glue Trigger(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Schema Variables
#############################
variable "create_schema" {
  type        = bool
  description = "Whether to create Glue Schema"
  default     = false
}

variable "schemas" {
  description = "Map of objects that define the AWS Glue Schema(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Job Variables
#############################
variable "create_job" {
  type        = bool
  description = "Whether to create Glue Schema"
  default     = false
}

variable "jobs" {
  description = "Map of objects that define the AWS Glue Schema(s) to be created."
  type        = any
  default     = []
}


#############################
# Glue Tags
#############################
variable "glue_tags" {
  description = "Tagging for AWS Glue components"
  type        = any
  default = {
    iac = "terraform"
  }
}
