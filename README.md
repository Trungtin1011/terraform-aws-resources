# custom-aws-glue 

**Repo Owner**: [trungtin](https://github.com/Trungtin1011/custom-apigateway-v1)

<a href="https://github.com/Trungtin1011/custom-aws-glue/releases/latest"><img src="https://img.shields.io/github/release/Trungtin1011/custom-aws-glue.svg?style=for-the-badge" alt="Latest Release"/></a>
<a href="https://github.com/Trungtin1011/custom-aws-glue/commits"><img src="https://img.shields.io/github/last-commit/Trungtin1011/custom-aws-glue.svg?style=for-the-badge" alt="Last Updated"/></a>


Terraform modules for provisioning and managing AWS [Glue](https://docs.aws.amazon.com/glue/latest/dg/what-is-glue.html) resources. 

The following Glue resources are supported:
> [AWS Glue Data Catalog Database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database)<br>
> [AWS Glue Data Catalog Table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table)<br>
> [AWS Glue Classifier](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_classifier)<br>
> [AWS Glue Connection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection)<br>
> [AWS Glue Crawler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler)<br>
> [AWS Glue Data Catalog Encryption Settings](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_catalog_encryption_settings)<br>
> [AWS Glue Job](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job)<br>
> [AWS Glue Partition](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition)<br>
> [AWS Glue Partition Index](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_partition_index)<br>
> [AWS Glue Schema Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry)<br>
> [AWS Glue Data Catalog Resource Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_resource_policy)<br>
> [AWS Glue Schema](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema)<br>
> [AWS Glue Data Catalog Security Configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_security_configuration)<br>
> [AWS Glue Trigger](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger)<br>
> [AWS Glue Workflow](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_workflow)

<br>

## Usage

AWS Glue Data Catalog is a persistent metadata store in AWS Glue. 

It contains definitions and information to create and monitor ETL jobs.

Each account has 1 Data Catalog per Region, so basically we don't need to specify the `catalog_id` variable as it will be the `accountID`

The original purpose of this module is to group all components that share the same **Data Catalog Database** into one place for better management (create - delete - modify)

The only required parameter in this module is **database_name**

If only **database_name** is provided, the module create **AWS Glue Schema Registry** resource along with the **Data Catalog Database** because these 2 resources share the same purpose as the central repository for other components

At the time the module is written, it required Terraform AWS provider version to be at least **v5.37.0** for all the configuration options to be fully functional.

### Notes about Glue Catalog Encryption Input Logic

**Connection Encryption** <br>

If `encrypt_connection` == false and `connection_encryption_key` == null:
> => Disable connection password encryption

If `encrypt_connection` == true and `connection_encryption_key` == null:
> => Use AWS managed customer master key (CMK) "alias/aws/glue" to encrypt.

If `encrypt_connection` == true and `connection_encryption_key` == `kms_key_arn`:
> => Use `kms_key_arn` to encrypt.

If `encrypt_connection` == false and `connection_encryption_key` == `kms_key_arn`:
> => `InvalidInputException` error for Glue Data Catalog Encryption Settings

<br>

**Encryption At-Rest** <br>

If `encryption_at_rest_mode` == `SSE-KMS` and `encryption_at_rest_key` == null:
> => Use AWS managed customer master key (CMK) "alias/aws/glue" to encrypt.

If `encryption_at_rest_mode` == `SSE-KMS` and `encryption_at_rest_key` == `kms_key_arn`:
> => Use `kms_key_arn` to encrypt.

If `encryption_at_rest_mode` == `SSE-KMS-WITH-SERVICE-ROLE`
> => An IAM role for working with KMS must be provided through `encryption_at_rest_role`

<br>

<br>

## Basic Examples

```hcl
module "aws_glue" {
  source               = "../custom-aws-glue?ref=v1.0.0"
  database_name        = "test_glue_database"
  database_description = "Glue Terraform module"
  glue_tags            = { owner = "trungtin" }

  enable_resource_policy        = false
  enable_catalog_encryption     = false
  enable_security_configuration = false
  create_connection             = false
  create_custom_classifier      = false
  create_crawler                = false
  create_workflow               = false
  create_trigger                = false
  create_schema                 = false
  create_job                    = false
}
```


Terraform will perform the following actions:
```hcl
# module.aws_glue.aws_glue_catalog_database.this will be created
+ resource "aws_glue_catalog_database" "this" {
    + arn          = (known after apply)
    + catalog_id   = (known after apply)
    + description  = "Glue Terraform module"
    + id           = (known after apply)
    + location_uri = (known after apply)
    + name         = "test_glue_database"
    + tags         = {
        + "owner" = "trungtin"
      }
    + tags_all     = {
        + "owner" = "trungtin"
      }
  }

# module.aws_glue.aws_glue_registry.this will be created
+ resource "aws_glue_registry" "this" {
    + arn           = (known after apply)
    + id            = (known after apply)
    + registry_name = "test_glue_database-registry"
    + tags          = {
        + "owner" = "trungtin"
      }
    + tags_all      = {
        + "owner" = "trungtin"
      }
  }

Plan: 2 to add, 0 to change, 0 to destroy.
```

Check for complete example at: [complete example](./examples/complete/main.tf)
<br>

## Providers

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.37.0 |

<br>

## Input Variables

| Name | Description | Type | Default | Required |
| :--- | :--- | :---: | :---: | :---: |
| **database_name** | (Required) Name of the database. The acceptable characters are lowercase letters, numbers, and the underscore character. | string | `null` | yes |
| **catalog_id** | (Optional) The ID of the Data Catalog to set the security configuration for. If none is provided, the AWS account ID is used by default. | string | `account_id` | no |
| **database_description** | (Optional) Description of the database. | string | `null` | no |
| **database_catalog_id** | (Optional) ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID | string | `Account ID` | no |
| **create_table_default_permission** | (Optional) Creates a set of default permissions on the table for principals. | map(any) | `null` | no |
| **database_location_uri** | (Optional) Location of the database (for example, an HDFS path). | string | `null` | no |
| **database_parameters** | (Optional) Map of key-value pairs that define parameters and properties of the database. | map(string) | `null` | no |
| **target_database** | (Optional) Configuration block for a target database for resource linking. | map(string) | `null` | no |
| **federated_database** | (Optional) Configuration block that references an entity outside the AWS Glue Data Catalog | map(string) | `null` | no |
| **glue_tags** | (Optional) Tagging values for all supported components | map(string) | `null` | no |
| **enable_resource_policy** | (Optional) Whether to create Glue Resource Policy | bool | `false` | no |
| **enable_catalog_encryption** | (Optional) Whether to enable Glue Data Catalog Encryption Settings | bool | `false` | no |
| **enable_security_configuration** | (Optional) Whether to enable Glue Data Catalog Security Configuration | bool | `false` | no |
| **encrypt_connection** | (Required when **enable_catalog_encryption** == true) <br>When set to true, passwords remain encrypted in the responses of GetConnection and GetConnections. This encryption takes effect independently of the catalog encryption.| bool | `false` | no |
| **enable_hybrid_policy** | (Optional, 'TRUE' or 'FALSE') Use both aws_glue_resource_policy and AWS Lake Formation resource policies to determine access permissions | string | `null` | no |
| **resource_policy** | (Required when **enable_resource_policy** == true ) <br>The policy to be applied to the aws glue data catalog. | string | `null` | no |
| **connection_encryption_key** | (Optional) A KMS key ARN that is used to encrypt the connection password. If connection password protection is enabled, the caller of CreateConnection and UpdateConnection needs at least kms:Encrypt permission on the specified AWS KMS key, to encrypt passwords before storing them in the Data Catalog | string | `null` | no |
| **encryption_at_rest_mode** | (Required when **enable_catalog_encryption** == true) <br>The encryption-at-rest mode for encrypting Data Catalog data. Valid values are DISABLED, SSE-KMS, SSE-KMS-WITH-SERVICE-ROLE. | string | `null` | no |
| **encryption_at_rest_role** | (Optional) The ARN of the AWS IAM role used for accessing encrypted Data Catalog data. | string | `null` | no |
| **encryption_at_rest_key** | (Optional) The ARN of the AWS KMS key to use for encryption at rest. | string | `null` | no |
| **security_configuration_name** | (Required when **enable_security_configuration** == true) <br>Name of the security configuration. | string | `null` | no |
| **cloudwatch_encryption_mode** | (Required when **enable_security_configuration** == true) <br>A block contains encryption configuration for CloudWatch. <br>Valid values are `DISABLED`, `SSE-KMS` | string | `null` | no |
| **cloudwatch_encryption_key** | (Optional) ARN of the KMS key to be used to encrypt the data. (SSE-KMS mode) | string | `null` | no |
| **bookmarks_encryption_mode** | (Required when **enable_security_configuration** == true) <br>A block contains encryption configuration for job bookmarks. <br>Valid values are DISABLED, CSE-KMS | string | `null` | no |
| **bookmarks_encryption_key** | (Optional) ARN of the KMS key to be used to encrypt the data. (CSE-KMS mode) | string | `null` | no |
| **s3_encryption_mode** | (Required when **enable_security_configuration** == true) <br>A block contains encryption configuration for S3. <br>Valid values are DISABLED, SSE-KMS, SSE-S3 | string | `null` | no |
| **s3_encryption_key** | (Optional) ARN of the KMS key to be used to encrypt the data. (SSE-KMS and SSE-S3 mode) | string | `null` | no |
| **create_connection** | (Optional) Whether to create AWS Glue Connection | bool | `false` | no |
| **create_crawler** | (Optional) Whether to create AWS Glue Crawler | bool | `false` | no |
| **create_custom_classifier** | (Optional) Whether to create AWS Glue Custom Classifier | bool | `false` | no |
| **create_workflow** | (Optional) Whether to create AWS Glue Workflow | bool | `false` | no |
| **create_trigger** | (Optional) Whether to create AWS Glue Trigger | bool | `false` | no |
| **create_schema** | (Optional) Whether to create AWS Glue Schema | bool | `false` | no |
| **create_job** | (Optional) Whether to create AWS Glue Job | bool | `false` | no |
| **connections** | (Optional) Map of objects that define the AWS Glue Connection(s) to be created.<br>Requried when **create_connection** is set to `true` | map(object) | `null` | no |
| **crawlers** | (Optional) Map of objects that define the AWS Glue Crawler(s) to be created.<br>Requried when **create_crawler** is set to `true` | map(object) | `null` | no |
| **custom_classifiers** | (Optional) Map of objects that define the AWS Glue Classifier(s) to be created.<br>Requried when **create_custom_classifier** is set to `true` | map(object) | `null` | no |
| **workflows** | (Optional) Map of objects that define the AWS Glue Workflow(s) to be created.<br>Requried when **create_workflow** is set to `true` | map(object) | `null` | no |
| **triggers** | (Optional) Map of objects that define the AWS Glue Trigger(s) to be created.<br>Requried when **create_trigger** is set to `true` | map(object) | `null` | no |
| **schemas** | (Optional) Map of objects that define the AWS Glue Schema(s) to be created.<br>Requried when **create_schema** is set to `true` | map(object) | `null` | no |
| **jobs** | (Optional) Map of objects that define the AWS Glue Schema(s) to be created.<br>Requried when **create_job** is set to `true` | map(object) | `null` | no |

<br>

## Output Variables

| Name | Description |
| :--- | :--- |
| **resource_policy** | AWS Glue Data Catalog Resource Policy. |
| **resource_policy_coverage** | The AWS Region where the policy is applied. |
| **catalog_id** | The ID of the Data Catalog the security configuration is being configured for. |
| **catalog_encryption_settings** | The Encryption Settings of the Data Catalog. |
| **security_configuration_name** | The Security Configuration Name of the Data Catalog. |
| **security_configuration_encryption** | The Security Configuration Encryption configs of the Data Catalog. |
| **db_id** | ID of the database. |
| **db_name** | Name of the database. |
| **db_arn** | ARN of the Glue Catalog Database. |
| **registry_id** | ARN of Glue Registry. |
| **registry_arn** | ARN of Glue Registry. |
| **connection_id** | ID of the connection. |
| **connection_name** |Name of the connection. |
| **connection_arn** |The ARN of the Glue Connection |
| **crawler_id** | ID of the crawler. |
| **crawler_name** | Name of the crawler. |
| **crawler_arn** | ARN of the crawler. |
| **custom_classifier_name** | Name of the custom classifier. |
| **workflow_id** | ID of Glue Workflow. |
| **workflow_name** | Name of Glue Workflow. |
| **workflow_arn** | ARN of Glue Workflow. |
| **trigger_id** | ID of Glue Trigger. |
| **trigger_name** | Name of Glue Trigger. |
| **trigger_arn** | ARN of Glue Trigger. |
| **schema_id** | ID of the schema. |
| **schema_name** | Name of the schema. |
| **schema_arn** | ARN of the schema. |
| **latest_schema_version** | The latest version of the schema associated with the returned schema definition. |
| **next_schema_version** | The next version of the schema associated with the returned schema definition. |
| **schema_checkpoint** | The version number of the checkpoint (the last time the compatibility mode was changed). |
| **job_id** | ID of Glue Job. |
| **job_name** | Name of Glue Job. |
| **job_arn** | ARN of Glue Job. |

<br>

## References

1. [Glue Getting Started Guide](https://docs.aws.amazon.com/glue/latest/dg/getting-started.html) - Guide for getting oriented with glue and spark
2. [AWS Glue programming guide](https://docs.aws.amazon.com/glue/latest/dg/edit-script.html) - Documentation about the process of programming with AWS Glue
3. [Python shell jobs in AWS Glue](https://docs.aws.amazon.com/glue/latest/dg/add-job-python.html) - Documentation about the process of configuring and running Python shell jobs in AWS Glue
4. [AWS Glue knowledge center](https://aws.amazon.com/premiumsupport/knowledge-center/glue-insufficient-lakeformation-permissions/) - Why does my AWS Glue crawler or ETL job fail with the error "Insufficient Lake Formation permission(s)"?
5. [AWS Glue Workshop](https://catalog.us-east-1.prod.workshops.aws/workshops/ee59d21b-4cb8-4b3d-a629-24537cf37bb5/en-US) - High-level guide for understanding AWS Glue and its components.

<br>

### Under development
> [AWS Glue Data Quality Ruleset](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_quality_ruleset)<br>
> [AWS Glue Dev Endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_dev_endpoint) - [(Has been removed from the Console since March 31, 2023)](https://docs.aws.amazon.com/glue/latest/dg/development.html#:~:text=The%20console%20experience%20for%20dev%20endpoints%20has%20been%20removed%20as%20of%20March%2031%2C%202023)<br>
> [AWS Glue ML Transform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_ml_transform)<br>
> [AWS Glue User Defined Function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_user_defined_function)<br>


<br>

## License
Private module