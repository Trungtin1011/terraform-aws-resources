# terraform-aws-cicd CodeCommit submodule

**Repo Owner**: trungtin

## Module structure and Usage

This terraform submodule supports provisioning and managing AWS CodeCommit resource.


<br>

The following resources are currently supported:
1. [AWS CodeCommit Repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository)
2. [AWS CodeCommit Approval Rule Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template)
3. [AWS CodeCommit Approval Rule Template Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template_association)
4. [AWS CodeCommit Trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_trigger)
5. [AWS CodeCommit Notification (AWS Developer Tools Notification Rule)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule)


<br>

At a very basic level, this submodule provide the ability to create and manage a basic CodeCommit repository with required configuration.

A basic examples of this submodule should looks like:

```hcl
module "aws_codecommit_repo" {
  source = "../../terraform-aws-cicd//submodules/codecommit"

  ### CodeCommit repository
  create_codecommit_repo         = true
  codecommit_repo_name           = "example-codecommit-repo"
  codecommit_repo_description    = "CodeCommit Repository"
  codecommit_repo_default_branch = "main"

  ### CodeCommit approval
  enable_repo_approval      = true
  codecommit_repo_approvers = ["arn:aws:sts::123456789012:assumed-role/CodeCommitReview/*"]
  number_of_approvers       = 2

  ### CodeCommit approval
  create_repo_trigger      = false
  trigger_on_all_branches  = false   # If false, trigger on codecommit_repo_default_branch only
  repo_trigger_events      = ["all"] # all, updateReference, createReference, deleteReference.
  repo_trigger_destination = "arn:aws:sns:ap-southeast-1:123456789012:sns-test-topic"

  ### CodeCommit notification rules
  codecommit_notifications = {
    detail_type = "BASIC"
    event_type_ids = [
      "codecommit-repository-comments-on-commits",
      "codecommit-repository-comments-on-pull-requests"
    ]
    targets = [
      {
        address = "arn:aws:sns:ap-southeast-1:123456789012:sns-test-topic-1"
        type    = "SNS" # AWS Chatbot (Teams), AWS Chatbot (Slack)
      },
      {
        address = "arn:aws:sns:ap-southeast-1:123456789012:sns-test-topic-2"
        type    = "SNS"
      }
    ]
  }

  tags = var.tags
}
```

Check for more examples at `../../examples`

<br>

## Terraform settings

### Required providers

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0 |

<br>

### Input Variables

| Name | Description | Type | Default | Required |
| :-- | :-- | :--: | :--: | :--: |
| **create_codecommit_repo** | (Optional) Whether to create AWS CodeCommit repository | bool | `false` | no |
| **codecommit_repo_name** | (Required) The name for the repository. This needs to be less than 100 characters. | string | `null` | yes |
| **codecommit_repo_description** | (Optional) The description of the repository. This needs to be less than 1000 characters | string | `null` | no |
| **codecommit_repo_default_branch** | (Optional) The default branch of the repository. The branch specified here needs to exist. | string | `null` | no |
| **repo_kms_key** | (Optional) The ARN of the encryption key. If no key is specified, the default `aws/codecommit`` Amazon Web Services managed key is used. | string | `null` | no |
| **enable_repo_approval** | (Optional) Whether to enable AWS CodeCommit repository approval processes | bool | `false` | no |
| **number_of_approvers** | (Optional) The number of approvers | number| `1` | no |
| **codecommit_repo_approvers** | ARNs of approvers | list(string) | `["*"]` | no |
| **create_repo_trigger** | (Optional) Whether to enable trigger for the repo | bool | `false` | no |
| **trigger_on_all_branches** | (Optional) Whether to enable trigger for all branches of the repo | bool | `false` | no |
| **trigger_events** | (Required if **create_repo_trigger** == true ) <br>The repository events that will cause the trigger to run actions in another service (all, updateReference, createReference, deleteReference) | list(string) | `["all"]` | no |
| **repo_trigger_destination** | (Required if **create_repo_trigger** == true ) <br>The ARN of the resource that is the target for a trigger (SNS or Lambda). | string | `null` | no |
| **codecommit_notifications** | (Optional) Notification rules for CodeCommit repository | map() | `{}` | no |
| **tags** | (Optional) Key-value map of resource tags. | map(string) | `{"iac" = "terraform"}` | no |

<br>

### Output Variables

| Name | Description |
| :--- | :--- |
| **code_repo_id** | The ID of the CodeCommit repository. |
| **code_repo_name** | The name of the CodeCommit repository. |
| **code_repo_arn** | The ARN of the CodeCommit repository. |
| **code_repo_http_url** | The URL to use for cloning the repository over HTTPS. |
| **code_repo_ssh_url** | The URL to use for cloning the repository over SSH. |
| **code_repo_approval_template_id** | Code repo approval template ID. |
| **codecommit_notification_id** | The notification rule ID. |
| **codecommit_notification_arn** | The notification rule ARN. |

<br>

## Additional Information

### Reference documentations

1. [AWS Developer Tools](https://docs.aws.amazon.com/dtconsole/latest/userguide/what-is-dtconsole.html) - Guide for getting oriented with AWS Developer Tools Console.
2. [AWS Developer Tool Notification Concepts](https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#concepts-api) - Basic notifications concepts of AWS Developer Tools Console.
3. [What is AWS CodeCommit?](https://docs.aws.amazon.com/codecommit/latest/userguide/welcome.html) - Guide for getting oriented with AWS CodeCommit basic concepts.
4. [What is AWS CodeBuild?](https://docs.aws.amazon.com/codebuild/latest/userguide/concepts.html) - Guide for getting oriented with AWS CodeBuild basic concepts.
5. [What is AWS CodeDeploy?](https://docs.aws.amazon.com/codedeploy/latest/userguide/primary-components.html) - Guide for getting oriented with AWS CodeDeploy basic concepts.
6. [What is AWS CodePipeline?](https://docs.aws.amazon.com/codepipeline/latest/userguide/concepts.html) - Guide for getting oriented with AWS CodePipeline basic concepts.
7. [CodePipeline Action Stuctures](https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference.html) - Documentation about action configuration in AWS CodePipeline
8. [CI/CD pipeline for Terraform using AWS CodePipeline](https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/create-a-ci-cd-pipeline-to-validate-terraform-configurations-by-using-aws-codepipeline.html) - How to test Terraform configurations by using CI/CD pipeline deployed by AWS CodePipeline
9. [AWS DevOps Pipeline Accelerator](https://docs.aws.amazon.com/prescriptive-guidance/latest/devops-pipeline-accelerator/introduction.html) - Standardizing IaC pipelines documentation

<br>

### License
Private module
