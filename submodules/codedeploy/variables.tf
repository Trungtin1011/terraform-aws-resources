####################################
# AWS CodeDeploy Variables
####################################
variable "create_codedeploy_application" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeDeploy application"
  default     = false
}

variable "codedeploy_application" {
  type        = any
  description = "(Required if **create_codedeploy_application** == true) AWS CodeDeploy application definition"
  default = {
    name     = null
    platform = null
  }
}

variable "use_custom_deployment_config" {
  type        = bool
  description = "(Optional) Whether to use custom AWS CodeDeploy Deployment config"
  default     = false
}

variable "custom_codedeploy_deployment_config" {
  type        = any
  description = "(Optional) Whether a custom AWS CodeDeploy Deployment Config is created"
  default     = {}
}

variable "create_codedeploy_deployment_group" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeDeploy Deployment Group"
  default     = false
}

variable "codedeploy_deployment_group_name" {
  type        = string
  description = "(Required if **create_codedeploy_deployment_group** == true) The name of the deployment group."
  default     = null
}

variable "create_codedeploy_deployment_role" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeDeploy Deployment IAM role"
  default     = true
}

variable "codedeploy_deployment_role_name" {
  type        = string
  description = "(Optional) Name of CodeDeploy Deployment IAM role to create"
  default     = "aws-codedeploy-default-role"
}

variable "codedeploy_deployment_role_description" {
  type        = string
  description = "(Optional) Description of CodeDeploy Deployment IAM role to create"
  default     = "IAM role created along with AWS CodeDeploy submodule"
}

variable "codedeploy_deployment_role_policy" {
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

variable "codedeploy_deployment_role_arn" {
  type        = string
  description = "(Optional) ARN of existing CodeDeploy Deployment IAM role to use"
  default     = null
}

variable "codedeploy_deployment_group_autoscaling_groups" {
  type        = list(string)
  description = "(Optional) Autoscaling groups associated with the deployment group."
  default     = []
}

variable "codedeploy_deployment_group_deployment_config_name" {
  type        = string
  description = "(Optional) The name of the group's deployment config. The default is **CodeDeployDefault.OneAtATime**."
  default     = null
}

variable "codedeploy_deployment_group_outdated_instances_strategy" {
  type        = string
  description = "(Optional) Configuration block of Indicates what happens when new Amazon EC2 instances are launched mid-deployment and do not receive the deployed application revision. Valid values are UPDATE and IGNORE. Defaults to UPDATE."
  default     = "UPDATE"
}

variable "codedeploy_deployment_group_alarm_configuration" {
  type        = any
  description = "(Optional) Configuration block of alarms associated with the deployment group."
  default     = null
}

variable "codedeploy_deployment_group_auto_rollback_configuration" {
  type        = any
  description = "(Optional) Configuration block of the automatic rollback configuration associated with the deployment group."
  default     = null
}

variable "codedeploy_deployment_group_blue_green_deployment_config" {
  type        = any
  description = "(Optional) Configuration block of the blue/green deployment options for a deployment group."
  default     = null
}

variable "codedeploy_deployment_group_deployment_style" {
  type        = any
  description = "(Optional) Configuration block of the type of deployment, either in-place or blue/green, you want to run and whether to route deployment traffic behind a load balancer."
  default     = null
}

variable "codedeploy_deployment_group_ec2_tag_filter" {
  type        = any
  description = "(Optional) Tag filters associated with the deployment group."
  default     = []
}

variable "codedeploy_deployment_group_ec2_tag_set" {
  type        = any
  description = "(Optional) Configuration block(s) of Tag filters associated with the deployment group, which are also referred to as tag groups."
  default     = []
}

variable "codedeploy_deployment_group_ecs_service" {
  type        = any
  description = "(Optional) Configuration block(s) of the ECS services for a deployment group."
  default     = null
}

variable "codedeploy_deployment_group_load_balancer_info" {
  type        = any
  description = "(Optional) Single configuration block of the load balancer to use in a blue/green deployment."
  default     = null
}

variable "codedeploy_deployment_group_on_premises_instance_tag_filter" {
  type        = any
  description = "(Optional) On premise tag filters associated with the group."
  default     = null
}

variable "codedeploy_deployment_group_trigger_configuration" {
  type        = any
  description = "(Optional) Configuration block(s) of the triggers for the deployment group."
  default     = null
}

variable "codedeploy_notifications" {
  type        = any
  description = "(Optional) Notification rules for CodeDeploy application"
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
