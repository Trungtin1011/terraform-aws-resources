####################################
# AWS Developer Tool Connection Outputs
####################################

output "additional_host_id" {
  description = "The connection host ID"
  value       = try(aws_codestarconnections_host.this[0].id, "")
}

output "additional_host_arn" {
  description = "The connection host ID"
  value       = try(aws_codestarconnections_host.this[0].arn, "")
}

output "additional_host_status" {
  description = "The connection host status"
  value       = try(aws_codestarconnections_host.this[0].status, "")
}
output "additional_connection_id" {
  description = "The connection ID"
  value       = try(aws_codestarconnections_connection.this[0].id, "")
}

output "additional_connection_arn" {
  description = "The connection ARN"
  value       = try(aws_codestarconnections_connection.this[0].arn, "")
}

output "additional_connection_status" {
  description = "The connection status"
  value       = try(aws_codestarconnections_connection.this[0].connection_status, "")
}


####################################
# AWS CodePipeline Outputs
####################################
output "pipeline_id" {
  description = "The codepipeline ID."
  value       = try(aws_codepipeline.this[0].id, "")
}

output "pipeline_arn" {
  description = "The codepipeline ARN."
  value       = try(aws_codepipeline.this[0].arn, "")
}

output "pipeline_custom_action_id" {
  description = "Composed of category, provider and version. For example, Build:terraform:1"
  value       = [for name in keys(aws_codepipeline_custom_action_type.this) : try(aws_codepipeline_custom_action_type.this[name].id, "")]
}

output "pipeline_custom_action_arn" {
  description = "Custom Action ARN"
  value       = [for name in keys(aws_codepipeline_custom_action_type.this) : try(aws_codepipeline_custom_action_type.this[name].arn, "")]
}

output "pipeline_webhook_id" {
  description = "The CodePipeline webhook's ID."
  value       = try(aws_codepipeline_webhook.this[0].id, "")
}

output "pipeline_webhook_arn" {
  description = "The CodePipeline webhook's ARN."
  value       = try(aws_codepipeline_webhook.this[0].arn, "")
}

output "pipeline_webhook_url" {
  description = "The CodePipeline webhook's URL. POST events to this endpoint to trigger the target."
  value       = try(aws_codepipeline_webhook.this[0].url, "")
}

output "pipeline_role_arn" {
  description = "ARN of default IAM role for the module"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "codepipeline_notification_id" {
  description = "The notification rule ID"
  value       = try(aws_codestarnotifications_notification_rule.this[0].id, "")
}

output "codepipeline_notification_arn" {
  description = "The notification rule ARN"
  value       = try(aws_codestarnotifications_notification_rule.this[0].arn, "")
}
