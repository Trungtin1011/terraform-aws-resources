####################################
# AWS CodeBuild Outputs
####################################
output "codebuild_project_arn" {
  description = "ARN of the CodeBuild project."
  value       = try(aws_codebuild_project.this[0].arn, "")
}

output "codebuild_project_badge_url" {
  description = "URL of the build badge when public access is enabled."
  value       = try(aws_codebuild_project.this[0].badge_url, "")
}

output "codebuild_project_id" {
  description = "Name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project."
  value       = try(aws_codebuild_project.this[0].id, "")
}

output "codebuild_public_project_alias" {
  description = "The project identifier used with the public build APIs."
  value       = try(aws_codebuild_project.this[0].public_project_alias, "")
}

output "codebuild_report_group_id" {
  description = "The ID of Report Group."
  value       = try(aws_codebuild_report_group.this[0].id, "")
}

output "codebuild_report_group_arn" {
  description = "The ARN of Report Group."
  value       = try(aws_codebuild_report_group.this[0].arn, "")
}

output "codebuild_report_group_created_date" {
  description = "The date and time this Report Group was created."
  value       = try(aws_codebuild_report_group.this[0].created, "")
}

output "codebuild_resource_policy" {
  description = "CodeBuild Resource Policy."
  value       = try(aws_codebuild_resource_policy.this[0].id, "")
}

output "codebuild_credential_id" {
  description = "The ID of CodeBuild Source Credential."
  value       = try(aws_codebuild_source_credential.this[0].id, "")
}

output "codebuild_credential_arn" {
  description = "The ARN of CodeBuild Source Credential."
  value       = try(aws_codebuild_source_credential.this[0].arn, "")
}

output "codebuild_webhook_id" {
  description = "The name of the build project."
  value       = try(aws_codebuild_webhook.this[0].id, "")
}

output "codebuild_webhook_url" {
  description = "The URL of the webhook."
  value       = try(aws_codebuild_webhook.this[0].url, "")
}

output "codebuild_webhook_payload" {
  description = "The CodeBuild endpoint where webhook events are sent."
  value       = try(aws_codebuild_webhook.this[0].payload_url, "")
}

output "codebuild_webhook_secret" {
  description = "The secret token of the associated repository. Not returned by the CodeBuild API for all source types."
  value       = try(aws_codebuild_webhook.this[0].secret, "")
}

output "codebuild_role_arn" {
  description = "ARN of default IAM role for the submodule"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "codebuild_notification_id" {
  description = "The notification rule ID"
  value       = try(aws_codestarnotifications_notification_rule.this[0].id, "")
}

output "codebuild_notification_arn" {
  description = "The notification rule ARN"
  value       = try(aws_codestarnotifications_notification_rule.this[0].arn, "")
}

output "codebuild_logs_group_arn" {
  description = "CodeBuild logs group ARN"
  value       = try(aws_cloudwatch_log_group.this[0].arn, "")
}
