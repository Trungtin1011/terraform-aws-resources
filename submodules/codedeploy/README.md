# terraform-aws-cicd CodeDeploy submodule

**Repo Owner**: trungtin

## Module structure and Usage

This terraform submodule supports provisioning and managing AWS CodeDeploy resource.


<br>

The following resources are currently supported:
1. [AWS CodeDeploy app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app)
2. [AWS CodeDeploy Deployment Config](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config)
3. [AWS CodeDeploy Deployment Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group)


<br>

At a very basic level, this submodule provide the ability to create and manage a basic CodeDeploy application with required configuration.

A basic examples of this submodule should looks like:

```hcl
module "aws_codedeploy" {
  source = "../../terraform-aws-cicd//submodules/codedeploy"

  ### AWS CodeDeploy settings
  create_codedeploy_application = true
  codedeploy_application = {
    name     = "example-codedeploy-app"
    platform = "Lambda"
  }

  ### Custom CodeDeploy deployment config
  use_custom_deployment_config = true
  custom_codedeploy_deployment_config = {
    name     = "example-deployment-config"
    platform = "Lambda"
    traffic_routing = {
      type = "TimeBasedLinear"

      time_based_linear = {
        interval   = 10
        percentage = 10
      }
    }
  }

  ### CodeDeploy deployment group
  create_codedeploy_deployment_group = true
  codedeploy_deployment_group_name   = "example-deployment-group"
  codedeploy_deployment_group_deployment_style = {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN" # IN_PLACE, BLUE_GREEN
  }
  # If use_custom_deployment_config = true, this will be overrided by custom_codedeploy_deployment_config
  codedeploy_deployment_group_deployment_config_name = "CodeDeployDefault.OneAtATime"


  ### CodeDeploy deployment group service role (Required)
  create_codedeploy_deployment_role      = true
  codedeploy_deployment_role_name        = "example-deployment-group-role"
  codedeploy_deployment_role_description = "CodeBuild IAM service role"
  codedeploy_deployment_role_policy      = "custom-policy-in-json-format"
  # codedeploy_deployment_role_arn = # Existing IAM role, use when create_codedeploy_deployment_role = false

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
| **create_codedeploy_application** | (Optional) Whether to create AWS CodeDeploy application | bool | `false` | no |
| **codedeploy_application** | (Required if **create_codedeploy_application** == true) AWS CodeDeploy application definition | map(string) | `{name=null, platform=null}` | no |
| **use_custom_deployment_config** | (Optional) Whether to use custom AWS CodeDeploy Deployment config | bool | `false` | no |
| **custom_codedeploy_deployment_config** | (Optional) Whether a custom AWS CodeDeploy Deployment Config is created | map() | `{}` | no |
| **create_codedeploy_deployment_group** | (Optional) Whether to create AWS CodeDeploy Deployment Group | bool | `false` | no |
| **codedeploy_deployment_group_name** | (Required if **create_codedeploy_deployment_group** == true) The name of the deployment group. | string | `null` | no |
| **create_codedeploy_deployment_role** | (Optional) Whether to create AWS CodeDeploy Deployment IAM role | bool | `true` | no |
| **codedeploy_deployment_role_name** | (Optional) Name of CodeDeploy Deployment IAM role to create | string | `aws-codedeploy-default-role` | no |
| **codedeploy_deployment_role_description** | (Optional) Description of CodeDeploy Deployment IAM role to create | string | `IAM role created along with AWS CodeDeploy submodule` | no |
| **codedeploy_deployment_role_policy** | (Optional) An additional policy document as JSON to attach to IAM role | bool | `codebuild:*, codecommit:*, codedeploy:*, codepipeline:*, lambda:*, s3:*, iam:*` | no |
| **codedeploy_deployment_role_arn** | (Optional) ARN of existing CodeDeploy Deployment IAM role to use | string | `null` | no |
| **codedeploy_deployment_group_autoscaling_groups** | (Optional) Autoscaling groups associated with the deployment group. | list(string) | `[]` | no |
| **codedeploy_deployment_group_deployment_config_name** | (Required if **use_custom_deployment_config** = false) The name of the group's deployment config. The default is **CodeDeployDefault.OneAtATime**. | string | `CodeDeployDefault.OneAtATime` | no |
| **codedeploy_deployment_group_outdated_instances_strategy** | (Optional) Configuration block of Indicates what happens when new Amazon EC2 instances are launched mid-deployment and do not receive the deployed application revision. Valid values are UPDATE and IGNORE. Defaults to UPDATE. | string | `UPDATE` | no |
| **codedeploy_deployment_group_alarm_configuration** | (Optional) Configuration block of alarms associated with the deployment group. | map() | `null` | no |
| **codedeploy_deployment_group_auto_rollback_configuration** | (Optional) Configuration block of the automatic rollback configuration associated with the deployment group. | map() | `null` | no |
| **codedeploy_deployment_group_blue_green_deployment_config** | (Optional) Configuration block of the blue/green deployment options for a deployment group. | map() | `null` | no |
| **codedeploy_deployment_group_deployment_style** | (Optional) Configuration block of the type of deployment, either in-place or blue/green, you want to run and whether to route deployment traffic behind a load balancer. | map() | `null` | no |
| **codedeploy_deployment_group_ec2_tag_filter** | (Optional) Tag filters associated with the deployment group. | list() | `[]` | no |
| **codedeploy_deployment_group_ec2_tag_set** | (Optional) Configuration block(s) of Tag filters associated with the deployment group, which are also referred to as tag groups. | list() | `[]` | no |
| **codedeploy_deployment_group_ecs_service** | (Optional) Configuration block(s) of the ECS services for a deployment group. | map() | `null` | no |
| **codedeploy_deployment_group_load_balancer_info** | (Optional) Single configuration block of the load balancer to use in a blue/green deployment. | map() | `null` | no |
| **codedeploy_deployment_group_on_premises_instance_tag_filter** | (Optional) On premise tag filters associated with the group. | map() | `null` | no |
| **codedeploy_deployment_group_trigger_configuration** | (Optional) Configuration block(s) of the triggers for the deployment group. | map() | `null` | no |
| **codedeploy_notifications** | (Optional) Notification rules for CodeDeploy application | map() | `{}` | no |
| **tags** | (Optional) Key-value map of resource tags. | map(string) | `{"iac" = "terraform"}` | no |

<br>

**Note**: About codedeploy_deployment_group_ec2_tag_filter and codedeploy_deployment_group_ec2_tag_set variables, the input should follow:

```
codedeploy_deployment_group_ec2_tag_set = [
  {
    key   = "tagset-key-1"
    type  = "KEY_AND_VALUE"
    value = "tagset-value-1"
  },
  {
    key   = "tagset-key-2"
    type  = "KEY_AND_VALUE"
    value = "tagset-value-2"
  }
]

codedeploy_deployment_group_ec2_tag_filter = [
  {
    key   = "tagfilter-key-1"
    type  = "KEY_AND_VALUE"
    value = "tagfilter-value-1"
  },
  {
    key   = "tagfilter-key-2"
    type  = "KEY_AND_VALUE"
    value = "tagfilter-value-2"
  }
]
```

The output would be:
```
+ ec2_tag_filter {
    + key   = "tagfilter-key-1"
    + type  = "KEY_AND_VALUE"
    + value = "tagfilter-value-1"
  }
+ ec2_tag_filter {
    + key   = "tagfilter-key-2"
    + type  = "KEY_AND_VALUE"
    + value = "tagfilter-value-2"
  }

+ ec2_tag_set {
    + ec2_tag_filter {
        + key   = "tagset-key-1"
        + type  = "KEY_AND_VALUE"
        + value = "tagset-value-1"
      }
    + ec2_tag_filter {
        + key   = "tagset-key-2"
        + type  = "KEY_AND_VALUE"
        + value = "tagset-value-2"
      }
  }
```

<br>

### Output Variables

| Name | Description |
| :--- | :--- |
| **codedeploy_app_arn** | The ARN of the CodeDeploy application. |
| **codedeploy_app_id** | Amazon's assigned ID for the application. |
| **codedeploy_application_id** | The application's ID. |
| **codedeploy_app_name** | The application's name. |
| **codedeploy_deployment_arn** | The ARN of the deployment config. |
| **codedeploy_deployment_name** | The deployment group's config name. |
| **codedeploy_deployment_id** | The AWS assigned deployment config id |
| **codedeploy_deployment_group_arn** | The ARN of the CodeDeploy deployment group. |
| **codedeploy_deployment_group_name** | Application name and deployment group name. |
| **codedeploy_deployment_group_id** | The ARN of the CodeDeploy deployment group. |
| **codedeploy_iam_arn** | ARN of default IAM role for the submodule |
| **codedeploy_notification_id** | The notification rule ID. |
| **codedeploy_notification_arn** | The notification rule ARN. |

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
