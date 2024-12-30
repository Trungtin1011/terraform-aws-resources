# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_resource_policy
resource "aws_glue_resource_policy" "this" {
  count = var.resource_policy != null ? 1 : 0

  policy        = var.resource_policy
  enable_hybrid = try(var.enable_hybrid_resource_policy, null)
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_data_catalog_encryption_settings
resource "aws_glue_data_catalog_encryption_settings" "this" {
  count = var.enable_catalog_encryption != false ? 1 : 0

  catalog_id = try(var.catalog_id, null)
  data_catalog_encryption_settings {
    connection_password_encryption {
      return_connection_password_encrypted = var.encrypt_connection
      aws_kms_key_id                       = var.encrypt_connection != false && try(var.connection_encryption_key, null) != null ? var.connection_encryption_key : null
    }

    encryption_at_rest {
      catalog_encryption_mode         = var.encryption_at_rest_mode
      sse_aws_kms_key_id              = try(var.encryption_at_rest_key, null)
      catalog_encryption_service_role = var.encryption_at_rest_mode == "SSE-KMS-WITH-SERVICE-ROLE" && try(var.encryption_at_rest_role, null) != null ? var.encryption_at_rest_role : null
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_security_configuration
resource "aws_glue_security_configuration" "this" {
  count = var.enable_catalog_encryption != false ? 1 : 0

  name = var.security_configuration_name

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = var.cloudwatch_encryption_mode
      kms_key_arn                = var.cloudwatch_encryption_mode != "DISABLED" && try(var.cloudwatch_encryption_key, null) != null ? var.cloudwatch_encryption_key : null
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = var.bookmarks_encryption_mode
      kms_key_arn                   = var.bookmarks_encryption_mode != "DISABLED" && try(var.bookmarks_encryption_key, null) != null ? var.bookmarks_encryption_key : null
    }

    s3_encryption {
      s3_encryption_mode = var.s3_encryption_mode
      kms_key_arn        = var.s3_encryption_mode != "DISABLED" && try(var.s3_encryption_key, null) != null ? var.s3_encryption_key : null
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database
resource "aws_glue_catalog_database" "this" {
  name         = var.database_name
  description  = try(var.database_description, null)
  catalog_id   = try(var.catalog_id, null)
  location_uri = try(var.database_location_uri, null)
  parameters   = try(var.database_parameters, null)
  tags         = var.glue_tags

  dynamic "create_table_default_permission" {
    for_each = try(var.create_table_default_permission, null) != null ? [true] : []

    content {
      permissions = try(var.create_table_default_permission.permissions, null)

      dynamic "principal" {
        for_each = try(var.create_table_default_permission.principal, null) != null ? [true] : []

        content {
          data_lake_principal_identifier = try(var.create_table_default_permission.principal.data_lake_principal_identifier, null)
        }
      }
    }
  }

  dynamic "target_database" {
    for_each = try(var.target_database, null) != null ? [true] : []

    content {
      catalog_id    = var.target_database.catalog_id
      database_name = var.target_database.database_name
      region        = try(var.target_database.region, null)
    }
  }

  dynamic "federated_database" {
    for_each = try(var.federated_database, null) != null ? [true] : []

    content {
      connection_name = try(var.federated_database.connection_name, null)
      identifier      = try(var.federated_database.identifier, null)
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_registry
# This resource will be created by default along with Database
resource "aws_glue_registry" "this" {
  registry_name = "${var.database_name}-registry"
  tags          = var.glue_tags

  depends_on = [aws_glue_catalog_database.this]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_connection
resource "aws_glue_connection" "this" {
  for_each = {
    for key in var.connections : key.name => {
      name                  = try(key.name, null)
      description           = try(key.description, null)
      catalog_id            = try(key.catalog_id, null)
      connection_type       = try(key.connection_type, null)
      connection_properties = try(key.connection_properties, null)
      match_criteria        = try(key.match_criteria, null)
      physical_connection   = try(key.physical_connection_requirements, null)
    }
    if var.create_connection != false
  }

  name                  = each.value.name
  description           = each.value.description
  catalog_id            = each.value.catalog_id
  connection_type       = each.value.connection_type
  connection_properties = each.value.connection_properties
  match_criteria        = each.value.match_criteria

  dynamic "physical_connection_requirements" {
    for_each = "${each.value.physical_connection}" != null ? [true] : []

    content {
      availability_zone      = try(each.value.physical_connection.availability_zone, null)
      security_group_id_list = try(each.value.physical_connection.security_group_id_list, null)
      subnet_id              = try(each.value.physical_connection.subnet_id, null)
    }
  }

  tags = var.glue_tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler
resource "aws_glue_crawler" "this" {
  for_each = {
    for key in var.crawlers : key.name => {
      name                         = try(key.name, null)
      description                  = try(key.description, null)
      role                         = try(key.role, null)
      schedule                     = try(key.schedule, null)
      classifiers                  = try(key.classifiers, null)
      configuration                = try(key.configuration, null)
      security_configuration       = try(key.security_configuration, null)
      table_prefix                 = try(key.table_prefix, null)
      catalog_target               = try(key.catalog_target, null)
      s3_target                    = try(key.s3_target, null)
      jdbc_target                  = try(key.jdbc_target, null)
      delta_target                 = try(key.delta_target, null)
      dynamodb_target              = try(key.dynamodb_target, null)
      mongodb_target               = try(key.mongodb_target, null)
      hudi_target                  = try(key.hudi_target, null)
      iceberg_target               = try(key.iceberg_target, null)
      lake_formation_configuration = try(key.lake_formation_configuration, null)
      lineage_configuration        = try(key.lineage_configuration, null)
      recrawl_policy               = try(key.recrawl_policy, null)
      schema_change_policy         = try(key.schema_change_policy, null)
    }
    if var.create_crawler != false
  }

  database_name          = aws_glue_catalog_database.this.name
  name                   = each.value.name
  description            = each.value.description
  role                   = each.value.role
  schedule               = each.value.schedule
  classifiers            = each.value.classifiers
  configuration          = each.value.configuration
  security_configuration = each.value.security_configuration
  table_prefix           = each.value.table_prefix

  dynamic "catalog_target" {
    for_each = "${each.value.catalog_target}" != null ? [true] : []

    content {
      database_name       = each.value.catalog_target.database_name
      tables              = each.value.catalog_target.tables
      connection_name     = try(each.value.catalog_target.connection_name, null)
      event_queue_arn     = try(each.value.catalog_target.event_queue_arn, null)
      dlq_event_queue_arn = try(each.value.catalog_target.dlq_event_queue_arn, null)
    }
  }

  dynamic "s3_target" {
    for_each = "${each.value.s3_target}" != null ? [true] : []

    content {
      path                = each.value.s3_target.path
      connection_name     = try(each.value.s3_target.connection_name, null)
      exclusions          = try(each.value.s3_target.exclusions, null)
      sample_size         = try(each.value.s3_target.sample_size, null)
      event_queue_arn     = try(each.value.s3_target.event_queue_arn, null)
      dlq_event_queue_arn = try(each.value.s3_target.dlq_event_queue_arn, null)
    }
  }

  dynamic "jdbc_target" {
    for_each = "${each.value.jdbc_target}" != null ? [true] : []

    content {
      connection_name            = each.value.jdbc_target.connection_name
      path                       = each.value.jdbc_target.path
      exclusions                 = try(each.value.jdbc_target.exclusions, null)
      enable_additional_metadata = try(each.value.jdbc_target.enable_additional_metadata, null)
    }
  }

  dynamic "delta_target" {
    for_each = "${each.value.delta_target}" != null ? [true] : []

    content {
      delta_tables              = each.value.delta_target.delta_tables
      write_manifest            = each.value.delta_target.write_manifest
      connection_name           = try(each.value.delta_target.connection_name, null)
      create_native_delta_table = try(each.value.delta_target.create_native_delta_table, null)
    }
  }

  dynamic "dynamodb_target" {
    for_each = "${each.value.dynamodb_target}" != null ? [true] : []

    content {
      path      = each.value.dynamodb_target.path
      scan_all  = try(each.value.dynamodb_target.scan_all, null)
      scan_rate = try(each.value.dynamodb_target.scan_rate, null)
    }
  }

  dynamic "mongodb_target" {
    for_each = "${each.value.mongodb_target}" != null ? [true] : []

    content {
      connection_name = each.value.mongodb_target.connection_name
      path            = each.value.mongodb_target.path
      scan_all        = try(each.value.mongodb_target.scan_all, null)
    }
  }

  dynamic "hudi_target" {
    for_each = "${each.value.hudi_target}" != null ? [true] : []

    content {
      paths                   = each.value.hudi_target.paths
      maximum_traversal_depth = each.value.hudi_target.maximum_traversal_depth
      connection_name         = try(each.value.hudi_target.connection_name, null)
      exclusions              = try(each.value.hudi_target.exclusions, null)
    }
  }

  dynamic "iceberg_target" {
    for_each = "${each.value.iceberg_target}" != null ? [true] : []

    content {
      paths                   = each.value.iceberg_target.paths
      maximum_traversal_depth = each.value.iceberg_target.maximum_traversal_depth
      connection_name         = try(each.value.iceberg_target.connection_name, null)
      exclusions              = try(each.value.iceberg_target.exclusions, null)
    }
  }

  dynamic "lake_formation_configuration" {
    for_each = "${each.value.lake_formation_configuration}" != null ? [true] : []

    content {
      account_id                     = each.value.lake_formation_configuration.account_id
      use_lake_formation_credentials = each.value.lake_formation_configuration.use_lake_formation_credentials
    }
  }

  dynamic "lineage_configuration" {
    for_each = "${each.value.lineage_configuration}" != null ? [true] : []

    content {
      crawler_lineage_settings = each.value.lineage_configuration.crawler_lineage_settings
    }
  }

  dynamic "schema_change_policy" {
    for_each = "${each.value.schema_change_policy}" != null ? [true] : []

    content {
      delete_behavior = each.value.schema_change_policy.delete_behavior
      update_behavior = each.value.schema_change_policy.update_behavior
    }
  }

  dynamic "recrawl_policy" {
    for_each = "${each.value.recrawl_policy}" != null ? [true] : []

    content {
      recrawl_behavior = each.value.recrawl_policy.recrawl_behavior
    }
  }

  tags       = var.glue_tags
  depends_on = [aws_glue_catalog_database.this]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_classifier
resource "aws_glue_classifier" "this" {
  for_each = {
    for key in var.custom_classifiers : key.name => {
      name            = try(key.name, null)
      csv_classifier  = try(key.csv_classifier, null)
      grok_classifier = try(key.grok_classifier, null)
      json_classifier = try(key.json_classifier, null)
      xml_classifier  = try(key.xml_classifier, null)
    }
    if var.create_custom_classifier != false
  }

  name = each.value.name

  dynamic "csv_classifier" {
    for_each = "${each.value.csv_classifier}" != null ? [true] : []

    content {
      allow_single_column        = try(each.value.csv_classifier.allow_single_column, null)
      contains_header            = try(each.value.csv_classifier.contains_header, null)
      custom_datatype_configured = try(each.value.csv_classifier.custom_datatype_configured, null)
      custom_datatypes           = try(each.value.csv_classifier.custom_datatypes, null)
      delimiter                  = try(each.value.csv_classifier.delimiter, null)
      disable_value_trimming     = try(each.value.csv_classifier.disable_value_trimming, null)
      header                     = try(each.value.csv_classifier.header, null)
      quote_symbol               = try(each.value.csv_classifier.quote_symbol, null)
    }
  }

  dynamic "grok_classifier" {
    for_each = "${each.value.grok_classifier}" != null ? [true] : []

    content {
      classification  = each.value.grok_classifier.classification
      custom_patterns = try(each.value.grok_classifier.custom_patterns, null)
      grok_pattern    = each.value.grok_classifier.grok_pattern
    }
  }

  dynamic "json_classifier" {
    for_each = "${each.value.json_classifier}" != null ? [true] : []

    content {
      json_path = each.value.json_classifier.json_path
    }
  }

  dynamic "xml_classifier" {
    for_each = "${each.value.xml_classifier}" != null ? [true] : []

    content {
      classification = each.value.xml_classifier.classification
      row_tag        = each.value.xml_classifier.row_tag
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_workflow
resource "aws_glue_workflow" "this" {
  for_each = {
    for key in var.workflows : key.name => {
      name                   = try(key.name, null)
      description            = try(key.description, null)
      default_run_properties = try(key.default_run_properties, null)
      max_concurrent_runs    = try(key.max_concurrent_runs, null)
    }
    if var.create_workflow != false
  }

  name                   = each.value.name
  description            = each.value.description
  default_run_properties = each.value.default_run_properties
  max_concurrent_runs    = each.value.max_concurrent_runs

  tags = var.glue_tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_trigger
resource "aws_glue_trigger" "this" {
  for_each = {
    for key in var.triggers : key.name => {
      type                     = try(key.type, null)
      name                     = try(key.name, null)
      actions                  = try(key.actions, null)
      description              = try(key.description, null)
      enabled                  = try(key.enabled, null)
      workflow_name            = try(key.workflow_name, null)
      predicate                = try(key.predicate, null)
      schedule                 = try(key.schedule, null)
      start_on_creation        = try(key.start_on_creation, null)
      event_batching_condition = try(key.event_batching_condition, null)
    }
    if var.create_trigger != false
  }

  name              = each.value.name
  description       = each.value.description
  workflow_name     = each.value.workflow_name
  type              = each.value.type
  schedule          = each.value.schedule
  enabled           = each.value.enabled
  start_on_creation = each.value.type == "ON_DEMAND" ? false : each.value.start_on_creation

  actions {
    job_name               = try(each.value.actions.job_name, null)
    crawler_name           = try(each.value.actions.crawler_name, null)
    arguments              = try(each.value.actions.arguments, null)
    security_configuration = try(each.value.actions.security_configuration, null)
    timeout                = try(each.value.actions.timeout, null)

    dynamic "notification_property" {
      for_each = try(each.value.actions.notification_property, null) != null ? [true] : []
      content {
        notify_delay_after = try(each.value.actions.notification_property.notify_delay_after, null)
      }
    }
  }

  dynamic "predicate" {
    for_each = "${each.value.predicate}" != null ? [true] : []

    content {
      logical = try(each.value.predicate.logical, null)

      conditions {
        job_name         = try(each.value.predicate.conditions.job_name, null)
        state            = try(each.value.predicate.conditions.state, null)
        crawler_name     = try(each.value.predicate.conditions.crawler_name, null)
        crawl_state      = try(each.value.predicate.conditions.crawl_state, null)
        logical_operator = try(each.value.predicate.conditions.logical_operator, null)
      }

    }
  }

  dynamic "event_batching_condition" {
    for_each = "${each.value.event_batching_condition}" != null ? [true] : []

    content {
      batch_size   = each.value.event_batching_condition.batch_size
      batch_window = try(each.value.event_batching_condition.batch_window, null)
    }
  }

  tags       = var.glue_tags
  depends_on = [aws_glue_catalog_database.this]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_schema
resource "aws_glue_schema" "this" {
  for_each = {
    for key in var.schemas : key.schema_name => {
      schema_name       = try(key.schema_name, null)
      description       = try(key.description, null)
      data_format       = try(key.data_format, null)
      compatibility     = try(key.compatibility, null)
      schema_definition = try(key.schema_definition, null)
    }
    if var.create_schema != false
  }

  registry_arn      = aws_glue_registry.this.arn
  schema_name       = each.value.schema_name
  description       = each.value.description
  data_format       = each.value.data_format
  compatibility     = each.value.compatibility
  schema_definition = each.value.schema_definition

  tags = var.glue_tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_job
resource "aws_glue_job" "this" {
  for_each = {
    for key in var.jobs : key.name => {
      name                      = try(key.name, null)
      command                   = try(key.command, null)
      role_arn                  = try(key.role_arn, null)
      description               = try(key.description, null)
      connections               = try(key.connections, null)
      default_arguments         = try(key.default_arguments, null)
      non_overridable_arguments = try(key.non_overridable_arguments, null)
      glue_version              = try(key.glue_version, null)
      timeout                   = try(key.timeout, null)
      execution_class           = try(key.execution_class, null)
      max_capacity              = try(key.max_capacity, null)
      max_retries               = try(key.max_retries, null)
      number_of_workers         = try(key.number_of_workers, null)
      worker_type               = try(key.worker_type, null)
      security_configuration    = try(key.security_configuration, null)
      notification_property     = try(key.notification_property, null)
      execution_property        = try(key.execution_property, null)
    }
    if var.create_job != false
  }

  name                      = each.value.name
  description               = each.value.description
  role_arn                  = each.value.role_arn
  connections               = each.value.connections
  default_arguments         = each.value.default_arguments
  non_overridable_arguments = each.value.non_overridable_arguments
  glue_version              = each.value.glue_version
  timeout                   = each.value.timeout
  execution_class           = each.value.execution_class
  max_capacity              = each.value.max_capacity
  max_retries               = each.value.max_retries
  number_of_workers         = each.value.number_of_workers
  worker_type               = each.value.worker_type
  security_configuration    = each.value.security_configuration

  command {
    name            = try(each.value.command.name, null)
    python_version  = try(each.value.command.python_version, null)
    script_location = each.value.command.script_location
    runtime         = try(each.value.command.runtime, null)
  }

  dynamic "notification_property" {
    for_each = "${each.value.notification_property}" != null ? [true] : []

    content {
      notify_delay_after = each.value.notification_property.notify_delay_after
    }
  }

  dynamic "execution_property" {
    for_each = "${each.value.execution_property}" != null ? [true] : []

    content {
      max_concurrent_runs = each.value.execution_property.max_concurrent_runs
    }
  }

  tags = var.glue_tags
}
