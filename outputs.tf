#############################
# Glue Resource Policy Outputs 
#############################
output "resource_policy" {
  description = "AWS Glue Data Catalog Resource Policy"
  value       = try(jsondecode(aws_glue_resource_policy.this[0].policy), "")
}

output "resource_policy_coverage" {
  description = "The AWS Region where the policy is applied"
  value       = try(aws_glue_resource_policy.this[0].id, "")
}


#############################
# Glue Catalog Encryption Outputs 
#############################
output "catalog_id" {
  description = "The ID of the Data Catalog the security configuration is being configured for"
  value       = try(aws_glue_data_catalog_encryption_settings.this[0].catalog_id, "")
}

output "catalog_encryption_settings" {
  description = "The Encryption Settings of the Data Catalog"
  value       = try(aws_glue_data_catalog_encryption_settings.this[0].data_catalog_encryption_settings, "")
}


#############################
# Glue Catalog Security Outputs 
#############################
output "security_configuration_name" {
  description = "The Security Configuration Name of the Data Catalog"
  value       = try(aws_glue_security_configuration.this[0].name, "")
}

output "security_configuration_encryption" {
  description = "The Security Configuration Encryption configs of the Data Catalog"
  value       = try(aws_glue_security_configuration.this[0].encryption_configuration, "")
}


#############################
# Catalog Database & Registry Outputs 
#############################
output "db_id" {
  description = "Glue catalog database ID"
  value       = try(aws_glue_catalog_database.this.id, "")
}

output "db_name" {
  description = "Glue catalog database name"
  value       = try(aws_glue_catalog_database.this.name, "")
}

output "db_arn" {
  description = "Glue catalog database ARN"
  value       = try(aws_glue_catalog_database.this.arn, "")
}

output "registry_id" {
  description = "Glue registry ID"
  value       = try(aws_glue_registry.this.id, "")
}

output "registry_arn" {
  description = "Glue registry ARN"
  value       = try(aws_glue_registry.this.arn, "")
}

#############################
# Glue Connection Outputs 
#############################
output "connection_id" {
  description = "Glue connection ID"
  value       = [for name in keys(aws_glue_connection.this) : aws_glue_connection.this[name].id]
}

output "connection_name" {
  description = "Glue connection name"
  value       = [for name in keys(aws_glue_connection.this) : aws_glue_connection.this[name].name]
}

output "connection_arn" {
  description = "Glue connection ARN"
  value       = [for name in keys(aws_glue_connection.this) : aws_glue_connection.this[name].arn]
}


#############################
# Glue Crawler Outputs 
#############################
output "crawler_id" {
  description = "Glue catalog crawler ID"
  value       = [for name in keys(aws_glue_crawler.this) : aws_glue_crawler.this[name].id]
}

output "crawler_name" {
  description = "Glue catalog crawler name"
  value       = [for name in keys(aws_glue_crawler.this) : aws_glue_crawler.this[name].name]
}

output "crawler_arn" {
  description = "Glue catalog crawler ARN"
  value       = [for name in keys(aws_glue_crawler.this) : aws_glue_crawler.this[name].arn]
}


#############################
# Glue Classifier Outputs 
#############################
output "custom_classifier_name" {
  description = "Glue catalog classifier name"
  value       = [for name in keys(aws_glue_classifier.this) : aws_glue_classifier.this[name].id]
}


#############################
# Glue Workflow Outputs 
#############################
output "workflow_id" {
  description = "Glue workflow ID"
  value       = [for name in keys(aws_glue_workflow.this) : aws_glue_workflow.this[name].id]
}

output "workflow_name" {
  description = "Glue workflow name"
  value       = [for name in keys(aws_glue_workflow.this) : aws_glue_workflow.this[name].name]
}

output "workflow_arn" {
  description = "Glue workflow ARN"
  value       = [for name in keys(aws_glue_workflow.this) : aws_glue_workflow.this[name].arn]
}


#############################
# Glue Trigger Outputs 
#############################
output "trigger_id" {
  description = "Glue trigger ID"
  value       = [for name in keys(aws_glue_trigger.this) : aws_glue_trigger.this[name].id]
}

output "trigger_name" {
  description = "Glue trigger name"
  value       = [for name in keys(aws_glue_trigger.this) : aws_glue_trigger.this[name].name]
}

output "trigger_arn" {
  description = "Glue trigger ARN"
  value       = [for name in keys(aws_glue_trigger.this) : aws_glue_trigger.this[name].arn]
}


#############################
# Glue Schema Outputs 
#############################
output "schema_id" {
  description = "Glue schema ID"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].id]
}

output "schema_name" {
  description = "Glue schema name"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].schema_name]
}

output "schema_arn" {
  description = "Glue schema ARN"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].arn]
}

output "latest_schema_version" {
  description = "The latest version of the schema associated with the returned schema definition"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].latest_schema_version]
}

output "next_schema_version" {
  description = "The next version of the schema associated with the returned schema definition"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].next_schema_version]
}

output "schema_checkpoint" {
  description = "The version number of the checkpoint (the last time the compatibility mode was changed)"
  value       = [for name in keys(aws_glue_schema.this) : aws_glue_schema.this[name].schema_checkpoint]
}


#############################
# Glue Job Outputs 
#############################
output "job_id" {
  description = "Glue job ID"
  value       = [for name in keys(aws_glue_job.this) : aws_glue_job.this[name].id]
}

output "job_name" {
  description = "Glue job name"
  value       = [for name in keys(aws_glue_job.this) : aws_glue_job.this[name].name]
}

output "job_arn" {
  description = "Glue job ARN"
  value       = [for name in keys(aws_glue_job.this) : aws_glue_job.this[name].arn]
}
