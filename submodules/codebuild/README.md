# terraform-aws-cicd CodeBuild submodule

**Repo Owner**: trungtin

## Module structure and Usage

This terraform submodule supports provisioning and managing AWS CodeBuild resource.


<br>

The following resources are currently supported:
1. [AWS CodeBuild Project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project)
2. [AWS CodeBuild Report Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_report_group)
3. [AWS CodeBuild Resource Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_resource_policy)
4 [AWS CodeBuild Source Credential](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential)
5. [AWS CodeBuild Webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook)


<br>

At a very basic level, this submodule provide the ability to create and manage a basic CodeBuild project with required configuration.

A basic examples of this submodule should looks like:

```hcl
module "aws_codebuild" {
  source = "../../terraform-aws-cicd//submodules/codebuild"

  ### CodeBuild project
  create_codebuild_project         = true
  codebuild_project_name           = "example-build-project"
  codebuild_project_description    = "CodeBuild example"
  codebuild_project_public_access  = false
  codebuild_project_visibility     = "PRIVATE"
  codebuild_project_build_timeout  = 60
  codebuild_project_queued_timeout = 480
  codebuild_project_logs_config = {
    cloudwatch_logs = {
      group_name  = "example-cw-loggroup"
      status      = "ENABLED"
      stream_name = "codebuild/"
    }
  }

  ### CodeBuild service role (Required)
  create_codebuild_role = false
  codebuild_role_arn    = aws_iam_role.existing_codebuild_role.arn

  ### CodeBuild source (Required)
  codebuild_source = {
    type            = "CODECOMMIT"
    location        = "${module.aws_codecommit_repo.code_repo_arn}"
    git_clone_depth = 1
    git_submodules_config = {
      fetch_submodules = true
    }
    buildspec = "buildspec.yaml"
  }

  ### CodeBuild artifacts (Required)
  codebuild_artifacts = {
    type = "NO_ARTIFACTS" # CODEPIPELINE, NO_ARTIFACTS, S3
  }

  ### CodeBuild environment (Required)
  codebuild_environment = {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false
    environment_variable = [
      {
        name  = "LAMBDA_FUNC_NAME"
        value = "${module.lambda_function.lambda_function_name}"
        type  = "PLAINTEXT" ### PARAMETER_STORE, SECRETS_MANAGER
      },
      {
        name  = "VARIABLE_2"
        value = "VALUE2"
        type  = "PLAINTEXT"
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
| **create_codebuild_project** | (Optional) Whether to create AWS CodeBuild project | bool | `false` | no |
| **codebuild_project_name** | (Required if **create_codebuild_project** == true) Project's name. | string | `null` | no |
| **codebuild_project_public_access** | (Optional) Generates a publicly-accessible URL for the projects build badge. Available as badge_url attribute when enabled | bool | `false` | no |
| **codebuild_project_build_timeout** | (Optional) Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes. The build_timeout property is not available on the Lambda compute type. | number | `60` | no |
| **codebuild_project_concurrent_build_limit** | (Optional) Specify a maximum number of concurrent builds for the project. The value specified must be greater than 0 and less than the account concurrent running builds limit. | number | `null` | no |
| **codebuild_project_description** | (Optional) Short description of the project. | string | `null` | no |
| **codebuild_project_encryption_key** | (Optional) AWS Key Management Service (AWS KMS) customer master key (CMK) to be used for encrypting the build project's build output artifacts. | string | `null` | no |
| **codebuild_project_visibility** | (Optional) Specifies the visibility of the project's builds. Possible values are: PUBLIC_READ and PRIVATE. Default value is PRIVATE. | string | `PRIVATE` | no |
| **codebuild_project_resource_access_role** | (Optional) The ARN of the IAM role that enables CodeBuild to access the CloudWatch Logs and Amazon S3 artifacts for the project's builds in order to display them publicly. Only applicable if project_visibility is PUBLIC_READ. | string | `null` | no |
| **codebuild_project_queued_timeout** | (Optional) Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. The default is 8 hours. The queued_timeout property is not available on the Lambda compute type. | number | `480` | no |
| **codebuild_project_source_version** | (Optional) Version of the build input to be built for this project. If not specified, the latest version is used. | string | `null` | no |
| **codebuild_project_batch_config** | (Optional) Defines the batch build options for the project. | map() | `null` | no |
| **codebuild_project_cache** | (Optional) Caching configs | map() | `null` | no |
| **codebuild_project_file_system_locations** | (Optional) A set of file system locations to mount inside the build. | map() | `null` | no |
| **codebuild_project_logs_config** | (Optional) Logging configs | map | `null` | no |
| **codebuild_project_secondary_artifacts** | (Optional) Additional Artifacts store | map() | `null` | no |
| **codebuild_project_secondary_sources** | (Optional) Additional Source | map() | `null` | no |
| **codebuild_project_secondary_source_version** | (Optional) Additional Source version | string | `null` | no |
| **codebuild_project_vpc_config** | (Optional) VPC Configs | map() | `null` | no |
| **codebuild_project_webhook** | (Optional) Whether an AWS CodeBuild Webhook is created | map() | `{}` | no |
| **codebuild_report_group** | (Optional) Whether an AWS CodeBuild Report Group is created | map() | `{}` | no |
| **codebuild_report_group_policy** | (Optional) A JSON-formatted resource policy for CodeBuild Report Group | list(object()) | `null` | no |
| **codebuild_credential** | (Optional) Whether an AWS CodeBuild Resource Credential is created | map() | `{}` | no |
| **codebuild_artifacts** | (Required if **create_codebuild_project** == true) CodeBuild artifacts definition | map() | `null` | condition |
| **codebuild_environment** | (Required if **create_codebuild_project** == true) CodeBuild environment definition | map() | `null` | condition |
| **codebuild_source** | (Required if **create_codebuild_project** == true) CodeBuild source definition | map() | `null` | condition |
| **create_codebuild_role** | (Optional) Whether to create AWS CodeBuild IAM role | bool | `true` | no |
| **codebuild_role_name** | (Optional) Name of CodeBuild IAM role to create | string | `aws-codebuild-default-role` | no |
| **codebuild_role_description** | (Optional) Description of CodeBuild IAM role to create | string | `IAM role created along with AWS CodeBuild submodule` | no |
| **codebuild_role_policy** | (Optional) An additional policy document as JSON to attach to IAM role | string | `codebuild:*, codecommit:*, codedeploy:*, codepipeline:*, lambda:*, s3:*, iam:*` | no |
| **codebuild_role_arn** | (Required if **create_codebuild_role** = false) ARN of existing CodeBuild IAM role to use | string | `null` | condition |
| **codebuild_notifications** | (Optional) Notification rules for CodeBuild project | map() | `{}` | no |
| **tags** | (Optional) Key-value map of resource tags. | map(string) | `{"iac" = "terraform"}` | no |

<br>

### Output Variables

| Name | Description |
| :--- | :--- |
| **codebuild_project_arn** | ARN of the CodeBuild project. |
| **codebuild_project_badge_url** | URL of the build badge when public access is enabled. |
| **codebuild_project_id** | Name (if imported via name) or ARN (if created via Terraform or imported via ARN) of the CodeBuild project. |
| **codebuild_public_project_alias** | The project identifier used with the public build APIs. |
| **codebuild_report_group_id** | The ID of Report Group. |
| **codebuild_report_group_arn** | The ARN of Report Group. |
| **codebuild_report_group_created_date** | The date and time this Report Group was created. |
| **codebuild_resource_policy** | CodeBuild Resource Policy. |
| **codebuild_credential_id** | The ID of CodeBuild Source Credential. |
| **codebuild_credential_arn** | The ARN of CodeBuild Source Credential. |
| **codebuild_webhook_id** | The name of the build project. |
| **codebuild_webhook_url** | The URL of the webhook. |
| **codebuild_webhook_payload** | The CodeBuild endpoint where webhook events are sent. |
| **codebuild_webhook_secret** | The secret token of the associated repository. Not returned by the CodeBuild API for all source types. |
| **codebuild_role_arn** | ARN of default IAM role for the submodule |
| **codebuild_notification_id** | The notification rule ID. |
| **codebuild_notification_arn** | The notification rule ARN. |

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
