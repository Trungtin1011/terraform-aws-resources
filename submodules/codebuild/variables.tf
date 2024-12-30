####################################
# AWS CodeBuild Variables
####################################
variable "create_codebuild_project" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeBuild project"
  default     = false
}

variable "codebuild_project_name" {
  type        = string
  description = "(Required if **create_codebuild_project** == true) Project's name."
  default     = null
}

variable "create_codebuild_role" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeBuild IAM role"
  default     = true
}

variable "codebuild_role_name" {
  type        = string
  description = "(Optional) Name of CodeBuild IAM role to create"
  default     = "aws-codebuild-default-role"
}

variable "codebuild_role_description" {
  type        = string
  description = "(Optional) Description of CodeBuild IAM role to create"
  default     = "IAM role created along with AWS CodeBuild submodule"
}

variable "codebuild_role_policy" {
  type        = string
  description = "(Optional) An additional policy document as JSON to attach to IAM role"
  default     = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["codebuild:*", "codecommit:*", "codedeploy:*", "codepipeline:*", "lambda:*", "s3:*", "iam:*", "sns:*", "elasticloadbalancing:*", "ecs:*", "autoscaling:*", "ec2:*", "cloudwatch:*", "tag:*"],
      "Resource": ["*"]
    }
  ]
}
EOF
}

variable "codebuild_role_arn" {
  type        = string
  description = "(Optional) ARN of existing CodeBuild IAM role to use"
  default     = null
}

variable "codebuild_artifacts" {
  type        = any
  description = "(Required if **create_codebuild_project** == true) CodeBuild artifacts definition"
  default     = null
}

variable "codebuild_environment" {
  type        = any
  description = "(Required if **create_codebuild_project** == true) CodeBuild environment definition"
  default     = null
}

variable "codebuild_source" {
  type        = any
  description = "(Required if **create_codebuild_project** == true) CodeBuild source definition"
  default     = null
}

variable "codebuild_project_public_access" {
  type        = bool
  description = "(Optional) Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled."
  default     = false
}

variable "codebuild_project_build_timeout" {
  type        = number
  description = "(Optional) Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes. The build_timeout property is not available on the Lambda compute type."
  default     = 60
}

variable "codebuild_project_concurrent_build_limit" {
  type        = number
  description = "(Optional) Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit."
  default     = null
}

variable "codebuild_project_description" {
  type        = string
  description = "(Optional) Short description of the project."
  default     = null
}

variable "codebuild_project_encryption_key" {
  type        = string
  description = "(Optional) AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts."
  default     = null
}

variable "codebuild_project_visibility" {
  type        = string
  description = "(Optional) Specifies the visibility of the project's builds. Possible values are: PUBLIC_READ and PRIVATE. Default value is PRIVATE."
  default     = "PRIVATE"
}

variable "codebuild_project_resource_access_role" {
  type        = string
  description = "(Optional) The ARN of the IAM role that enables CodeBuild to access the CloudWatch Logs and Amazon S3 artifacts for the project's builds in order to display them publicly. Only applicable if project_visibility is PUBLIC_READ."
  default     = null
}

variable "codebuild_project_queued_timeout" {
  type        = number
  description = "(Optional) Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours. The queued_timeout property is not available on the Lambda compute type."
  default     = 480
}

variable "codebuild_project_source_version" {
  type        = string
  description = "(Optional) Version of the build input to be built for this project. If not specified, the latest version is used."
  default     = null
}

variable "codebuild_project_batch_config" {
  type        = any
  description = "(Optional) Defines the batch build options for the project."
  default     = null
}

variable "codebuild_project_cache" {
  type        = any
  description = "(Optional) Caching configs"
  default     = null
}

variable "codebuild_project_file_system_locations" {
  type        = any
  description = "(Optional) A set of file system locations to mount inside the build."
  default     = null
}

variable "codebuild_project_logs_config" {
  type        = any
  description = "(Optional) Logging configs"
  default     = null
}

variable "codebuild_project_secondary_artifacts" {
  type        = any
  description = "(Optional) Additional Artifacts store"
  default     = null
}

variable "codebuild_project_secondary_sources" {
  type        = any
  description = "(Optional) Additional Source"
  default     = null
}

variable "codebuild_project_secondary_source_version" {
  type        = any
  description = "(Optional) Additional Source version"
  default     = null
}

variable "codebuild_project_vpc_config" {
  type        = any
  description = "(Optional) VPC Configs"
  default     = null
}

variable "codebuild_project_webhook" {
  type        = any
  description = "(Optional) Whether an AWS CodeBuild Webhook is created"
  default     = {}
}

variable "codebuild_report_group" {
  type        = any
  description = "(Optional) Whether an AWS CodeBuild Report Group is created"
  default     = {}
}

variable "codebuild_report_group_policy" {
  type = list(object(
    {
      Sid       = string
      Principal = map(string)
      Action    = list(string)
    }
  ))
  description = "(Optional) A JSON-formatted resource policy for CodeBuild Report Group"
  default     = null
}

variable "codebuild_credential" {
  type        = any
  description = "(Optional) Whether an AWS CodeBuild Resource Credential is created"
  default     = {}
}

variable "codebuild_notifications" {
  type        = any
  description = "(Optional) Notification rules for CodeBuild project"
  default     = {}
}


####################################
# Tagging Variables
####################################
variable "tags" {
  type        = map(string)
  description = "(Optional) Key-value map of resource tags."
  default = {
    "iac" = "terraform"
  }
}
