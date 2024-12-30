####################################
# AWS CodeDeploy Outputs
####################################
output "codedeploy_app_arn" {
  description = "The ARN of the CodeDeploy application."
  value       = try(aws_codedeploy_app.this[0].arn, "")
}

output "codedeploy_app_id" {
  description = "Amazon's assigned ID for the application."
  value       = try(aws_codedeploy_app.this[0].id, "")
}

output "codedeploy_application_id" {
  description = "The application ID."
  value       = try(aws_codedeploy_app.this[0].application_id, "")
}

output "codedeploy_app_name" {
  description = "The application's name."
  value       = try(aws_codedeploy_app.this[0].name, "")
}

output "codedeploy_deployment_arn" {
  description = "The ARN of the deployment config."
  value       = try(aws_codedeploy_deployment_config.this[0].arn, "")
}

output "codedeploy_deployment_name" {
  description = "The deployment group's config name."
  value       = try(aws_codedeploy_deployment_config.this[0].id, "")
}

output "codedeploy_deployment_id" {
  description = "The AWS assigned deployment config id"
  value       = try(aws_codedeploy_deployment_config.this[0].deployment_config_id, "")
}

output "codedeploy_deployment_group_arn" {
  description = "The ARN of the CodeDeploy deployment group."
  value       = try(aws_codedeploy_deployment_group.this[0].arn, "")
}

output "codedeploy_deployment_group_name" {
  description = "Application name and deployment group name."
  value       = try(aws_codedeploy_deployment_group.this[0].deployment_group_name, "")
}

output "codedeploy_deployment_group_id" {
  description = "The ARN of the CodeDeploy deployment group."
  value       = try(aws_codedeploy_deployment_group.this[0].deployment_group_id, "")
}

output "codedeploy_iam_arn" {
  description = "ARN of default IAM role for the submodule"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "codedeploy_notification_id" {
  description = "The notification rule ID"
  value       = try(aws_codestarnotifications_notification_rule.this[0].id, "")
}

output "codedeploy_notification_arn" {
  description = "The notification rule ARN"
  value       = try(aws_codestarnotifications_notification_rule.this[0].arn, "")
}
