####################################
# AWS CodeCommit Outputs
####################################
output "code_repo_id" {
  description = "The ID of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].repository_id, "")
}

output "code_repo_name" {
  description = "The name of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].repository_name, "")
}

output "code_repo_arn" {
  description = "The ARN of the CodeCommit repository."
  value       = try(aws_codecommit_repository.this[0].arn, "")
}

output "code_repo_http_url" {
  description = "The URL to use for cloning the repository over HTTPS."
  value       = try(aws_codecommit_repository.this[0].clone_url_http, "")
}

output "code_repo_ssh_url" {
  description = "The URL to use for cloning the repository over SSH."
  value       = try(aws_codecommit_repository.this[0].clone_url_ssh, "")
}

output "code_repo_approval_template_id" {
  description = "Code repo approval template ID."
  value       = try(aws_codecommit_approval_rule_template.this[0].approval_rule_template_id, "")
}

output "codecommit_notification_id" {
  description = "The notification rule ID"
  value       = try(aws_codestarnotifications_notification_rule.this[0].id, "")
}

output "codecommit_notification_arn" {
  description = "The notification rule ARN"
  value       = try(aws_codestarnotifications_notification_rule.this[0].arn, "")
}
