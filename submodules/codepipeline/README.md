# terraform-aws-cicd module

**Repo Owner**: trungtin

## Module structure and Usage

This terraform module supports provisioning and managing AWS Developer Tools services .

The main services in the module is AWS CodePipeline.

Other services are organized into submodules: [CodeCommit](./submodules/codecommit) submodule, [CodeBuild](./submodules/codebuild) submodule, and [CodeDeploy](./submodules/codedeploy) submodule

<br>

The following resources are currently supported:
1. [AWS Developer Tools Connection Host](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_host)
2. [AWS Developer Tools Connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection)
3. [AWS CodeBuild Project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project)
4. [AWS CodeBuild Report Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_report_group)
5. [AWS CodeBuild Resoiurce Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_resource_policy)
6. [AWS CodeBuild Source Credential](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential)
7. [AWS CodeBuild Webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook)
8. [AWS CodeCommit Repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository)
9. [AWS CodeCommit Approval Rule Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template)
10. [AWS CodeCommit Approval Rule Template Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template_association)
11. [AWS CodeCommit Trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_trigger)
12. [AWS CodeCommit Notification (AWS Developer Tools Notification Rule)](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule)
13. [AWS CodePipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)
14. [AWS CodePipeline Custom Action Type](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_custom_action_type)
15. [AWS CodePipeline Webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook)
16. [AWS CodeDeploy app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app)
17. [AWS CodeDeploy Deployment Config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config)
18. [AWS CodeDeploy Deployment Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group)

<br>

At a very basic level, this module provide the ability to create and manage a basic CodePipeline pipeline with required configuration.

A basic examples of this module that sync data from a S3 bucket to another S3 bucket when data changes should looks like:

```hcl
### This pipeline sync data from a S3 bucket to another S3 bucket
module "aws_pipeline" {
  source = "../../terraform-aws-cicd"

  # CodePipeline basic
  create_pipeline = true
  codepipeline_basic = {
    name           = "example-pipeline"
    execution_mode = "QUEUED"
    pipeline_type  = "V2"
  }

  # CodePipeline service role (Required)
  create_pipeline_role = false
  pipeline_role_arn    = aws_iam_role.existing_codepipeline_role.arn

  # CodePipeline artifacts store (Required)
  pipeline_artifacts = [
    {
      location = "${module.artifact_bucket.s3_bucket_id}"
      type     = "S3"
    }
  ]

  # CodePipelien stages (Required at least TWO stages)
  pipeline_stages = [
  {
     stage_name = "Source"
     ### S3 source
     action = {
       action_name      = "s3Src"
       category         = "Source"
       owner            = "AWS"
       provider         = "S3"
       version          = "1"
       output_artifacts = ["s3_output"]
       run_order        = 1
       configuration = {
         S3Bucket             = "${module.source_bucket.s3_bucket_id}"
         S3ObjectKey          = "src/hello.py"
         PollForSourceChanges = true ### If = false must use EventBridge to trigger pipeline
       }
     }
   },
    {
      stage_name = "Deploy"
      ### Deploy to S3
      action = {
        action_name     = "s3Des"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "S3"
        version         = "1"
        input_artifacts = ["s3_output"]
        run_order       = 1
        configuration = {
          BucketName = "${module.destination_bucket.s3_bucket_id}"
          Extract    = true
        }
      }
    },
  ]

  tags = var.tags
}
```

Check for more examples at `./examples`

<br>
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
| **enable_additional_settings** | (Optional) Enable Developer Tools Settings (hosts and connections) | bool | `false` | no |
| **additional_settings** | (Required if **enable_additional_settings** == true). Configure Connections and Hosts | map(object) | `{connection = {}, host = {}}` | no |
| **create_pipeline** | (Optional) Whether to create AWS CodePipeline pipeline | bool | `false` | no |
| **codepipeline_basic** | (Required) Basic configuration for CodePipeline: `name`, `execution_mode`, and `pipeline_type` | map(string) | `{}` | yes |
| **create_pipeline_role** | (Optional) Whether to create AWS CodePipeline IAM role | bool | `true` | condition |
| **pipeline_role_name** | (Optional) Name of CodePipeline IAM role to create | string | `aws-codepipeline-default-role` | no |
| **pipeline_role_description** | (Optional) Description of CodePipeline IAM role to create | string | `IAM role created along with AWS CICD module` | no |
| **pipeline_role_policy** | (Optional) An additional policy document as JSON to attach to IAM role | string | `codebuild:*, codecommit:*, codedeploy:*, codepipeline:*, lambda:*, s3:*, iam:*` | no |
| **pipeline_role_arn** | (Required if **create_pipeline_role** == false) Existing service role ARN. | string | `null` | condition |
| **pipeline_trigger** | (Optional) A trigger block. Valid only when pipeline_type is V2. | map(string) | `null` | no |
| **pipeline_variables** | (Optional) A pipeline-level variable block. Valid only when pipeline_type is V2. | map(string) | `null` | no |
| **pipeline_artifacts** | (Required) One or more artifact_store blocks | list(object) | `[]` | yes |
| **pipeline_stages** | (At least **TWO** stage blocks is required) A stage block | list(object) | `null` | yes |
| **pipeline_custom_actions** | (Optional) List of CodePipeline custom actions | list(object) | `[]` | no |
| **pipeline_webhook** | (Optional) Whether to create AWS CodePipeline Webhook | map(object) | `{}` | no |
| **codepipeline_notifications** | (Optional) Notification rules for CodePipeline pipeline | map() | `{}` | no |
| **tags** | (Optional) Key-value map of resource tags. | map(string) | `{"iac" = "terraform"}` | no |

<br>

### Output Variables

| Name | Description |
| :-- | :-- |
| **additional_host_id** | The connection host ID |
| **additional_host_arn** | The connection host ID |
| **additional_host_status** | The connection host status |
| **additional_connection_id** | The connection ID. |
| **additional_connection_arn** | The connection ARN. |
| **additional_connection_status** | The connection status |
| **pipeline_id** | The codepipeline ID. |
| **pipeline_arn** | The codepipeline ARN. |
| **pipeline_custom_action_id** | Composed of category, provider and version. For example, Build:terraform:1 |
| **pipeline_custom_action_arn** | Custom Action ARN |
| **pipeline_webhook_id** | The CodePipeline webhook's ID. |
| **pipeline_webhook_arn** | The CodePipeline webhook's ARN. |
| **pipeline_webhook_url** | The CodePipeline webhook's URL. POST events to this endpoint to trigger the target. |
| **pipeline_role_arn** | ARN of default created IAM role for the module |
| **codepipeline_notification_id** | The notification rule ID. |
| **codepipeline_notification_arn** | The notification rule ARN. |

<br>
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
10. [AWS Developer Tool events for notification rules](https://docs.aws.amazon.com/dtconsole/latest/userguide/concepts.html#concepts-api) - Event name for developer tools

<br>

### Resources under development

1. [AWS CodeArtifact Domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain)
2. [AWS CodeArtifact Domain Permission Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_domain_permissions_policy)
3. [AWS CodeArtifact Repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository)
4. [AWS CodeArtifact Repository Permission Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codeartifact_repository_permissions_policy)
5. [AWS CodeGuru Profiler Profiling Groups](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/codeguruprofiler_profiling_group)
6. [AWS CodeGuru Reviewer Repository Association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codegurureviewer_repository_association)

<br>

### License
Private module
