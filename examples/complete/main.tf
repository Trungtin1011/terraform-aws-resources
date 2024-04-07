module "glue" {
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

  ### Data Catalog Resource Policy
  resource_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect    = "Allow"
          Resource  = ["arn:${data.aws_partition.current.partition}:glue:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:table/*"]
          Action    = ["glue:CreateTable"]
          Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        }
      ]
    }
  )

  ### Data Catalog Encryption
  encrypt_connection        = true
  connection_encryption_key = "${module.kms.key_arn}"
  encryption_at_rest_mode = "SSE-KMS-WITH-SERVICE-ROLE"
  encryption_at_rest_key  = "${module.kms.key_arn}"
  encryption_at_rest_role = "${aws_iam_role.kms_role.arn}"

  ### Data Catalog Security Configuration
  security_configuration_name   = "test_security_config"
  cloudwatch_encryption_mode    = "SSE-KMS"
  cloudwatch_encryption_key     = "${module.kms.key_arn}"
  bookmarks_encryption_mode     = "CSE-KMS"
  bookmarks_encryption_key      = "${module.kms.key_arn}"
  s3_encryption_mode            = "SSE-KMS"
  s3_encryption_key             = "${module.kms.key_arn}"

  custom_classifiers = [
    {
      name = "test_classifier"
      json_classifier = {
        json_path = "$[*]"
      }
    }
  ]

  connections = [
    {
      name            = "test_connection"
      description     = "Test Glue Connection using Terraform module"
      connection_type = "NETWORK"
      physical_connection_requirements = {
        availability_zone      = "<AZ_NAME>"
        security_group_id_list = ["<SG_ID>"]
        subnet_id              = "<SUBNET_ID>"
      }
    }
  ]

  crawlers = [
    {
      name         = "test_crawler"
      description  = "Test Glue Crawler using Terraform module"
      role         = "<GLUE_ROLE_ARN>"
      table_prefix = ""
      s3_target = {
        path            = "s3://<BUCKET_NAME_TO_CRAWL>"
        connection_name = "test_connection"
      }
      schedule       = "cron(0 */8 * * ? *)"
      recrawl_policy = { recrawl_behavior = "CRAWL_EVERYTHING" }
      schema_change_policy = {
        delete_behavior = "DELETE_FROM_DATABASE"
        update_behavior = "UPDATE_IN_DATABASE"
      }
    }
  ]

  jobs = [
    {
      name              = "test_job"
      description       = "Test Glue Job using Terraform module"
      role_arn          = "<GLUE_ROLE_ARN>"
      connections       = ["test_connection"]
      glue_version      = "4.0"
      timeout           = 5 # minutes, up to 2880
      max_retries       = 2
      worker_type       = "G.1X"
      number_of_workers = 2

      command = {
        name            = "glueetl"
        script_location = "s3://<BUCKET_NAME_STORE_SCRIPT>/hello-world.py"
        python_version  = 3
      }

      default_arguments = {
        "--JOB_NAME"            = "test_job"
        "--enable-job-insights" = true,
        "--job-language"        = "python",
      }
    }
  ]

  schemas = [
    {
      schema_name       = "test_schema"
      description       = "Test Glue Schema using Terraform module"
      data_format       = "AVRO"
      compatibility     = "NONE"
      schema_definition = "{\"type\": \"record\", \"name\": \"r1\", \"fields\": [ {\"name\": \"f1\", \"type\": \"int\"}, {\"name\": \"f2\", \"type\": \"string\"} ]}"
    }
  ]

  triggers = [
    {
      name              = "test_trigger_01"
      description       = "Test Glue Trigger using Terraform module"
      enabled           = true
      workflow_name     = "test_workflow_01"
      type              = "ON_DEMAND"
      start_on_creation = false
      actions = {
        crawler_name = "test_crawler"
      }
    },
    {
      name          = "test_trigger_02"
      description   = "Test Glue Trigger using Terraform module"
      enabled       = true
      workflow_name = "test_workflow_01"
      type          = "CONDITIONAL"
      actions = {
        job_name = "test_job"
      }
      predicate = {
        logical = "AND"
        conditions = {
          crawler_name     = "test_crawler"
          logical_operator = "EQUALS"
          crawl_state      = "SUCCEEDED"
        }
      }
    }
  ]

  workflows = [
    {
      name        = "test_workflow_01"
      description = "Test Glue Workflow using Terraform module"
    },
    {
      name        = "test_workflow_02"
      description = "Test Glue Workflow using Terraform module"
    }
  ]
}

output "resource_policy" { value = module.catalog_sec.resource_policy }
output "resource_policy_coverage" { value = module.catalog_sec.resource_policy_coverage }
output "catalog_id" { value = module.catalog_sec.catalog_id }
output "catalog_encryption_settings" { value = module.catalog_sec.catalog_encryption_settings }
output "security_configuration_name" { value = module.catalog_sec.security_configuration_name }
output "security_configuration_encryption" { value = module.catalog_sec.security_configuration_encryption }
output "database_arn" { value = module.glue.db_arn }
output "registry_arn" { value = module.glue.registry_arn }
output "connection_arn" { value = module.glue.connection_arn }
output "crawler_arn" { value = module.glue.crawler_arn }
output "custom_classifier_name" { value = module.glue.custom_classifier_name }
output "workflow_arn" { value = module.glue.workflow_arn }
output "trigger_arn" { value = module.glue.trigger_arn }
output "schema_arn" { value = module.glue.schema_arn }
output "schema_name" { value = module.glue.schema_name }
output "job_id" { value = module.glue.job_id }
output "job_name" { value = module.glue.job_name }
output "job_arn" { value = module.glue.job_arn }