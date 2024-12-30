####################################
# AWS Developer Tools Connection Settings
####################################
variable "enable_additional_settings" {
  type        = bool
  description = "(Optional) Enable Developer Tools Settings"
  default     = false
}

variable "additional_settings" {
  type        = any
  description = "(Required if **enable_additional_settings** == true). Configure Connections and Hosts"
  default = {
    connection = {}
    host       = {}
  }
}


####################################
# AWS CodePipeline Variables
####################################
variable "create_pipeline" {
  type        = bool
  description = "(Optional) Whether to create AWS CodePipeline pipeline"
  default     = false
}

variable "codepipeline_basic" {
  type        = any
  description = "(Required if **create_pipeline** == true). Basic configuration for CodePipeline"
  default     = {}
}

variable "create_pipeline_role" {
  type        = bool
  description = "(Optional) Whether to create AWS CodePipeline IAM role"
  default     = true
}

variable "pipeline_role_name" {
  type        = string
  description = "(Optional) Name of CodePipeline IAM role to create"
  default     = "aws-codepipeline-default-role"
}

variable "pipeline_role_description" {
  type        = string
  description = "(Optional) Description of CodePipeline IAM role to create"
  default     = "IAM role created along with AWS CICD module"
}

variable "pipeline_role_policy" {
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

variable "pipeline_role_arn" {
  type        = string
  description = "ARN of existing CodePipeline IAM role to use"
  default     = null
}

variable "pipeline_trigger" {
  type        = any
  description = "(Optional) A trigger block. Valid only when pipeline_type is V2."
  default     = null
}

variable "pipeline_variables" {
  type        = any
  description = "(Optional) A pipeline-level variable block. Valid only when pipeline_type is V2."
  default     = null
}

variable "pipeline_artifacts" {
  type        = any
  description = "(Required) One or more artifact_store blocks"
  default     = []
}

variable "pipeline_stages" {
  type        = any
  description = "(At least two stage blocks is required) A stage block"
  default     = []
}

variable "pipeline_custom_actions" {
  type        = any
  description = "(Optional) AWS CodePipeline CustomActionType"
  default     = []
}

variable "pipeline_webhook" {
  type        = any
  description = "(Optional) Whether to create AWS CodePipeline Webhook"
  default     = {}
}

variable "codepipeline_notifications" {
  type        = any
  description = "(Optional) Notification rules for CodePipeline pipeline"
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
