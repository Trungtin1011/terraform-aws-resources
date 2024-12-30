### AWS CodeBuild ###
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project
resource "aws_codebuild_project" "this" {
  count = var.create_codebuild_project != false ? 1 : 0

  name                   = var.codebuild_project_name
  service_role           = var.create_codebuild_role != false ? aws_iam_role.this[0].arn : var.codebuild_role_arn
  badge_enabled          = try(var.codebuild_project_public_access, null)
  build_timeout          = try(var.codebuild_project_build_timeout, null)
  concurrent_build_limit = try(var.codebuild_project_concurrent_build_limit, null)
  description            = try(var.codebuild_project_description, null)
  encryption_key         = try(var.codebuild_project_encryption_key, null)
  project_visibility     = try(var.codebuild_project_visibility, null)
  resource_access_role   = try(var.codebuild_project_resource_access_role, null)
  queued_timeout         = try(var.codebuild_project_queued_timeout, null)
  source_version         = try(var.codebuild_project_source_version, null)

  dynamic "artifacts" {
    for_each = try(var.codebuild_artifacts, null) != null ? [true] : []

    content {
      type                   = var.codebuild_artifacts.type
      artifact_identifier    = try(var.codebuild_artifacts.artifact_identifier, null)
      bucket_owner_access    = try(var.codebuild_artifacts.bucket_owner_access, null)
      encryption_disabled    = try(var.codebuild_artifacts.encryption_disabled, null)
      location               = try(var.codebuild_artifacts.location, null)
      name                   = try(var.codebuild_artifacts.name, null)
      namespace_type         = try(var.codebuild_artifacts.namespace_type, null)
      override_artifact_name = try(var.codebuild_artifacts.override_artifact_name, null)
      packaging              = try(var.codebuild_artifacts.packaging, null)
      path                   = try(var.codebuild_artifacts.path, null)
    }
  }

  dynamic "environment" {
    for_each = try(var.codebuild_environment, null) != null ? [true] : []

    content {
      compute_type                = var.codebuild_environment.compute_type
      image                       = var.codebuild_environment.image
      type                        = var.codebuild_environment.type
      certificate                 = try(var.codebuild_environment.certificate, null)
      image_pull_credentials_type = try(var.codebuild_environment.image_pull_credentials_type, null)
      privileged_mode             = try(var.codebuild_environment.privileged_mode, null)

      dynamic "environment_variable" {
        for_each = var.codebuild_environment.environment_variable

        content {
          type  = try(environment_variable.value.type, null)
          name  = environment_variable.value.name
          value = environment_variable.value.value
        }
      }

      dynamic "registry_credential" {
        for_each = try(var.codebuild_environment.registry_credential, null) != null ? [true] : []

        content {
          credential          = var.codebuild_environment.registry_credential.credential
          credential_provider = var.codebuild_environment.registry_credential.credential_provider
        }
      }
    }
  }

  dynamic "source" {
    for_each = try(var.codebuild_source, null) != null ? [true] : []

    content {
      type                = var.codebuild_source.type
      buildspec           = try(var.codebuild_source.buildspec, null)
      git_clone_depth     = try(var.codebuild_source.git_clone_depth, null)
      insecure_ssl        = try(var.codebuild_source.insecure_ssl, null)
      location            = try(var.codebuild_source.location, null)
      report_build_status = try(var.codebuild_source.report_build_status, null)

      dynamic "build_status_config" {
        for_each = try(var.codebuild_source.build_status_config, null) != null ? [true] : []

        content {
          context    = try(var.codebuild_source.build_status_config.context, null)
          target_url = try(var.codebuild_source.build_status_config.target_url, null)
        }
      }

      dynamic "git_submodules_config" {
        for_each = try(var.codebuild_source.git_submodules_config, null) != null ? [true] : []

        content {
          fetch_submodules = var.codebuild_source.git_submodules_config.fetch_submodules
        }
      }
    }
  }

  dynamic "build_batch_config" {
    for_each = try(var.codebuild_project_batch_config, null) != null ? [true] : []

    content {
      service_role      = var.codebuild_project_batch_config.service_role
      combine_artifacts = try(var.codebuild_project_batch_config.combine_artifacts, null)
      timeout_in_mins   = try(var.codebuild_project_batch_config.timeout_in_mins, null)

      dynamic "restrictions" {
        for_each = try(var.codebuild_project_batch_config.restrictions, null) != null ? [true] : []

        content {
          compute_types_allowed  = try(var.codebuild_project_batch_config.restrictions.compute_types_allowed, null)
          maximum_builds_allowed = try(var.codebuild_project_batch_config.restrictions.maximum_builds_allowed, null)
        }
      }
    }
  }

  dynamic "cache" {
    for_each = try(var.codebuild_project_cache, null) != null ? [true] : []

    content {
      location = try(var.codebuild_project_cache.location, null)
      modes    = try(var.codebuild_project_cache.modes, null)
      type     = try(var.codebuild_project_cache.type, null)
    }
  }

  dynamic "file_system_locations" {
    for_each = try(var.codebuild_project_file_system_locations, null) != null ? [true] : []

    content {
      identifier    = try(var.codebuild_project_file_system_locations.identifier, null)
      location      = try(var.codebuild_project_file_system_locations.location, null)
      mount_options = try(var.codebuild_project_file_system_locations.mount_options, null)
      mount_point   = try(var.codebuild_project_file_system_locations.mount_point, null)
      type          = try(var.codebuild_project_file_system_locations.type, null)
    }
  }

  dynamic "logs_config" {
    for_each = try(var.codebuild_project_logs_config, null) != null ? [true] : []

    content {
      dynamic "cloudwatch_logs" {
        for_each = try(var.codebuild_project_logs_config.cloudwatch_logs, null) != null ? [true] : []

        content {
          group_name  = try(var.codebuild_project_logs_config.cloudwatch_logs.group_name, null)
          status      = "ENABLED"
          stream_name = try(var.codebuild_project_logs_config.cloudwatch_logs.stream_name, null)
        }
      }

      dynamic "s3_logs" {
        for_each = try(var.codebuild_project_logs_config.s3_logs, null) != null ? [true] : []

        content {
          encryption_disabled = try(var.codebuild_project_logs_config.s3_logs.encryption_disabled, null)
          location            = try(var.codebuild_project_logs_config.s3_logs.location, null)
          status              = try(var.codebuild_project_logs_config.s3_logs.status, null)
          bucket_owner_access = try(var.codebuild_project_logs_config.s3_logs.bucket_owner_access, null)
        }
      }
    }
  }

  dynamic "secondary_artifacts" {
    for_each = try(var.codebuild_project_secondary_artifacts, null) != null ? [true] : []

    content {
      artifact_identifier    = var.codebuild_project_secondary_artifacts.artifact_identifier
      type                   = var.codebuild_project_secondary_artifacts.type
      bucket_owner_access    = try(var.codebuild_project_secondary_artifacts.bucket_owner_access, null)
      encryption_disabled    = try(var.codebuild_project_secondary_artifacts.encryption_disabled, null)
      location               = try(var.codebuild_project_secondary_artifacts.location, null)
      name                   = try(var.codebuild_project_secondary_artifacts.name, null)
      namespace_type         = try(var.codebuild_project_secondary_artifacts.namespace_type, null)
      override_artifact_name = try(var.codebuild_project_secondary_artifacts.override_artifact_name, null)
      packaging              = try(var.codebuild_project_secondary_artifacts.packaging, null)
      path                   = try(var.codebuild_project_secondary_artifacts.path, null)
    }
  }

  dynamic "secondary_sources" {
    for_each = try(var.codebuild_project_secondary_sources, null) != null ? [true] : []

    content {
      source_identifier   = var.codebuild_project_secondary_sources.source_identifier
      type                = var.codebuild_project_secondary_sources.type
      buildspec           = try(var.codebuild_project_secondary_sources.buildspec, null)
      git_clone_depth     = try(var.codebuild_project_secondary_sources.git_clone_depth, null)
      insecure_ssl        = try(var.codebuild_project_secondary_sources.insecure_ssl, null)
      location            = try(var.codebuild_project_secondary_sources.location, null)
      report_build_status = try(var.codebuild_project_secondary_sources.report_build_status, null)

      dynamic "build_status_config" {
        for_each = try(var.codebuild_project_secondary_sources.build_status_config, null) != null ? [true] : []

        content {
          context    = try(var.codebuild_project_secondary_sources.build_status_config.context, null)
          target_url = try(var.codebuild_project_secondary_sources.build_status_config.target_url, null)
        }
      }

      dynamic "git_submodules_config" {
        for_each = try(var.codebuild_project_secondary_sources.git_submodules_config, null) != null ? [true] : []

        content {
          fetch_submodules = var.codebuild_project_secondary_sources.git_submodules_config.fetch_submodules
        }
      }
    }
  }

  dynamic "secondary_source_version" {
    for_each = try(var.codebuild_project_secondary_source_version, null) != null ? [true] : []

    content {
      source_identifier = var.codebuild_project_secondary_source_version.source_identifier
      source_version    = var.codebuild_project_secondary_source_version.source_version
    }
  }

  dynamic "vpc_config" {
    for_each = try(var.codebuild_project_vpc_config, null) != null ? [true] : []

    content {
      security_group_ids = var.codebuild_project_vpc_config.security_group_ids
      subnets            = var.codebuild_project_vpc_config.subnets
      vpc_id             = var.codebuild_project_vpc_config.vpc_id
    }
  }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_webhook
resource "aws_codebuild_webhook" "this" {
  count = var.codebuild_project_webhook != {} && var.create_codebuild_project != false ? 1 : 0

  project_name  = aws_codebuild_project.this[0].name
  build_type    = try(var.codebuild_project_webhook.build_type, null)
  branch_filter = try(var.codebuild_project_webhook.branch_filter, null)

  dynamic "filter_group" {
    for_each = try(var.codebuild_project_webhook.filter_group, null) != null ? [true] : []

    content {
      dynamic "filter" {
        for_each = var.codebuild_project_webhook.filter_group

        content {
          type                    = filter.value.type
          pattern                 = filter.value.pattern
          exclude_matched_pattern = try(filter.value.exclude_matched_pattern, false)
        }
      }
    }
  }

  #  dynamic "scope_configuration" {
  #    for_each = try(var.codebuild_project_webhook.scope_configuration, null) != null ? [true] : []
  #
  #    content {
  #      name   = var.codebuild_project_webhook.scope_configuration.name
  #      scope  = var.codebuild_project_webhook.scope_configuration.scope
  #      domain = try(var.codebuild_project_webhook.scope_configuration.domain, null)
  #    }
  #  }
  depends_on = [aws_codebuild_project.this]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_report_group
resource "aws_codebuild_report_group" "this" {
  count = var.codebuild_report_group != {} ? 1 : 0

  name           = var.codebuild_report_group.name
  type           = var.codebuild_report_group.type
  delete_reports = try(var.codebuild_report_group.delete_reports, null)

  dynamic "export_config" {
    for_each = try(var.codebuild_report_group.export_config, null) != null ? [true] : []

    content {
      type = var.codebuild_report_group.export_config.type

      dynamic "s3_destination" {
        for_each = try(var.codebuild_report_group.export_config.s3_destination, null) != null ? [true] : []

        content {
          bucket              = var.codebuild_report_group.export_config.s3_destination.bucket
          encryption_key      = var.codebuild_report_group.export_config.s3_destination.encryption_key
          encryption_disabled = try(var.codebuild_report_group.export_config.s3_destination.encryption_disabled, null)
          packaging           = try(var.codebuild_report_group.export_configs.s3_destination.packaging, null)
          path                = try(var.codebuild_report_group.export_config.s3_destination.path, null)
        }
      }
    }
  }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_resource_policy
resource "aws_codebuild_resource_policy" "this" {
  count = var.codebuild_report_group_policy != null && var.codebuild_report_group != {} ? 1 : 0

  resource_arn = aws_codebuild_report_group.this[0].arn
  policy = jsonencode(
    {
      Version = "2012-10-17"
      Id      = "default"
      Statement = [
        for plc in var.codebuild_report_group_policy : merge(
          plc,
          {
            Resource = "${aws_codebuild_report_group.this[0].arn}"
            Effect   = "Allow"
          }
        )
      ]
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_source_credential
resource "aws_codebuild_source_credential" "this" {
  count = var.codebuild_credential != {} ? 1 : 0

  auth_type   = var.codebuild_credential.auth_type
  server_type = var.codebuild_credential.server_type
  token       = var.codebuild_credential.token
  user_name   = try(var.codebuild_credential.username, null)
}

# CodeBuild notification rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
resource "aws_codestarnotifications_notification_rule" "this" {
  count = var.codebuild_notifications != {} && var.create_codebuild_project != false ? 1 : 0

  status   = "ENABLED"
  resource = aws_codebuild_project.this[0].arn
  name     = "${var.codebuild_project_name}-notification-rule"

  detail_type    = var.codebuild_notifications.detail_type
  event_type_ids = var.codebuild_notifications.event_type_ids

  dynamic "target" {
    for_each = var.codebuild_notifications.targets

    content {
      address = target.value.address
      type    = try(target.value.type, "SNS")
    }
  }
  tags       = var.tags
  depends_on = [aws_codebuild_project.this]
}


####################################
# Supporting Resources
####################################
resource "aws_iam_role" "this" {
  count = var.create_codebuild_role != false && var.create_codebuild_project != false ? 1 : 0

  name        = var.codebuild_role_name
  description = var.codebuild_role_description
  tags = merge(
    var.tags,
    {
      default = "submodule_aws_codebuild"
    }
  )
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "assumeRole"
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = [
            "codebuild.amazonaws.com"
          ]
        }
      }
    ]
  })
  inline_policy {
    name   = "default-codebuild-policy"
    policy = var.codebuild_role_policy
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count             = try(var.codebuild_project_logs_config.cloudwatch_logs, {}) != {} ? 1 : 0
  name              = try(var.codebuild_project_logs_config.cloudwatch_logs.group_name, var.codebuild_project_name)
  log_group_class   = "STANDARD"
  retention_in_days = try(var.codebuild_project_logs_config.cloudwatch_logs.retention, 7)
  skip_destroy      = try(var.codebuild_project_logs_config.cloudwatch_logs.keep_on_termination, false)
  kms_key_id        = try(var.codebuild_project_logs_config.cloudwatch_logs.kms_key_id, null)
  tags              = var.tags
  depends_on        = [aws_codebuild_project.this]
}
