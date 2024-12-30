####################################
# AWS CodeCommit Variables
####################################
variable "create_codecommit_repo" {
  type        = bool
  description = "(Optional) Whether to create AWS CodeCommit repository"
  default     = false
}

variable "codecommit_repo_name" {
  type        = string
  description = "(Required) The name for the repository. This needs to be less than 100 characters."
  default     = null
}

variable "codecommit_repo_description" {
  type        = string
  description = "(Optional) The description of the repository. This needs to be less than 1000 characters"
  default     = null
}

variable "codecommit_repo_default_branch" {
  type        = string
  description = "(Optional) The default branch of the repository. The branch specified here needs to exist."
  default     = null
}

variable "repo_kms_key" {
  type        = string
  description = "(Optional) The ARN of the encryption key. If no key is specified, the default `aws/codecommit`` Amazon Web Services managed key is used."
  default     = null
}

variable "enable_repo_approval" {
  type        = bool
  description = "(Optional) Whether to enable AWS CodeCommit repository approval processes"
  default     = false
}

variable "number_of_approvers" {
  type        = number
  description = "(Optional) The number of approvers"
  default     = 1
}

variable "codecommit_repo_approvers" {
  type        = list(string)
  description = "ARNs of approvers"
  default     = ["*"]
}

variable "create_repo_trigger" {
  type        = bool
  description = "(Optional) Whether to enable trigger for the repo"
  default     = false
}

variable "trigger_on_all_branches" {
  type        = bool
  description = "(Optional) Whether to enable trigger for all branches of the repo"
  default     = false
}

variable "trigger_events" {
  type        = list(string)
  description = "(Required if **create_repo_trigger** == true ) The repository events that will cause the trigger to run actions in another service (all, updateReference, createReference, deleteReference) "
  default     = ["all"]
}

variable "repo_trigger_destination" {
  type        = string
  description = "(Required if **create_repo_trigger** == true ) The ARN of the resource that is the target for a trigger (SNS or Lambda)."
  default     = ""
}

variable "codecommit_notifications" {
  type        = any
  description = "(Optional) Notification rules for CodeCommit repository"
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
