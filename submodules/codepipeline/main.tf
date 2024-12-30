### AWS Developer Tools Additional Settings ###
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_host
resource "aws_codestarconnections_host" "this" {
  count = var.enable_additional_settings != false ? 1 : 0

  name              = var.additional_settings.host.host_name
  provider_endpoint = var.additional_settings.host.host_endpoint
  provider_type     = var.additional_settings.host.host_type # Bitbucket, GitHub, GitHubEnterpriseServer, GitLab, GitLabSelfManaged

  dynamic "vpc_configuration" {
    for_each = var.additional_settings.host.host_vpc_configs != {} ? [true] : []

    content {
      vpc_id             = var.additional_settings.host.host_vpc_configs.vpc_id
      subnet_ids         = var.additional_settings.host.host_vpc_configs.subnet_ids
      security_group_ids = var.additional_settings.host.host_vpc_configs.security_group_ids
      tls_certificate    = try(var.additional_settings.host.host_vpc_configs.tls_certificate, null)
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarconnections_connection
resource "aws_codestarconnections_connection" "this" {
  count = var.enable_additional_settings != false ? 1 : 0

  name          = var.additional_settings.connection.connection_name
  provider_type = var.additional_settings.host != {} || try(var.additional_settings.connection.host_arn, null) != null ? null : var.additional_settings.connection.connection_type
  host_arn      = var.additional_settings.host != {} ? aws_codestarconnections_host.this[0].arn : try(var.additional_settings.connection.host_arn, null)
  tags          = var.tags
}


### AWS CodePipeline ##
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline
resource "aws_codepipeline" "this" {
  count = var.create_pipeline != false && var.codepipeline_basic != {} ? 1 : 0

  name           = var.codepipeline_basic.name
  execution_mode = try(var.codepipeline_basic.execution_mode, null)
  pipeline_type  = try(var.codepipeline_basic.pipeline_type, null)
  role_arn       = var.create_pipeline_role != false ? aws_iam_role.this[0].arn : var.pipeline_role_arn
  tags           = var.tags

  dynamic "trigger" {
    for_each = try(var.pipeline_trigger, null) != null ? [true] : []

    content {
      provider_type = var.pipeline_trigger.provider_type
      git_configuration {
        source_action_name = var.pipeline_trigger.git_configuration.source_action_name

        dynamic "pull_request" {
          for_each = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request, null) != null ? [true] : []

          content {
            events = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.events, null)

            dynamic "branches" {
              for_each = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.branches, null) != null ? [true] : []

              content {
                includes = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.branches.includes, null)
                excludes = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.branches.excludes, null)
              }
            }

            dynamic "file_paths" {
              for_each = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.file_paths, null) != null ? [true] : []

              content {
                includes = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.file_paths.includes, null)
                excludes = try(var.pipeline_trigger.git_configuration.source_action_name.pull_request.file_paths.excludes, null)
              }
            }
          }
        }

        dynamic "push" {
          for_each = try(var.pipeline_trigger.git_configuration.source_action_name.push, null) != null ? [true] : []

          content {
            dynamic "branches" {
              for_each = try(var.pipeline_trigger.git_configuration.source_action_name.push.branches, null) != null ? [true] : []

              content {
                includes = try(var.pipeline_trigger.git_configuration.source_action_name.push.branches.includes, null)
                excludes = try(var.pipeline_trigger.git_configuration.source_action_name.push.branches.excludes, null)
              }
            }

            dynamic "file_paths" {
              for_each = try(var.pipeline_trigger.git_configuration.source_action_name.push.file_paths, null) != null ? [true] : []

              content {
                includes = try(var.pipeline_trigger.git_configuration.source_action_name.push.file_paths.includes, null)
                excludes = try(var.pipeline_trigger.git_configuration.source_action_name.push.file_paths.excludes, null)
              }
            }

            dynamic "tags" {
              for_each = try(var.pipeline_trigger.git_configuration.source_action_name.push.tags, null) != null ? [true] : []

              content {
                includes = try(var.pipeline_trigger.git_configuration.source_action_name.push.tags.includes, null)
                excludes = try(var.pipeline_trigger.git_configuration.source_action_name.push.tags.excludes, null)
              }
            }
          }
        }
      }
    }
  }

  dynamic "variable" {
    for_each = try(var.pipeline_variables, null) != null ? [true] : []

    content {
      name          = var.pipeline_variables.name
      default_value = try(var.pipeline_variables.default_value, null)
      description   = try(var.pipeline_variables.description, null)
    }
  }

  dynamic "artifact_store" {
    for_each = var.pipeline_artifacts

    content {
      location = artifact_store.value.location
      type     = artifact_store.value.type
      region   = try(artifact_store.value.region, null)

      dynamic "encryption_key" {
        for_each = try(artifact_store.value.encryption_key, null) != null ? [true] : []

        content {
          id   = artifact_store.value.encryption_key.id
          type = "KMS"
        }
      }
    }
  }

  dynamic "stage" {
    for_each = var.pipeline_stages

    content {
      name = stage.value.stage_name

      action {
        name             = stage.value.action.action_name
        category         = stage.value.action.category
        owner            = stage.value.action.owner
        provider         = stage.value.action.provider
        version          = stage.value.action.version
        region           = try(stage.value.action.region, null)
        namespace        = try(stage.value.action.namespace, null)
        input_artifacts  = try(stage.value.action.input_artifacts, null)
        output_artifacts = try(stage.value.action.output_artifacts, null)
        run_order        = try(stage.value.action.run_order, null)
        configuration    = try(stage.value.action.configuration, null)
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_custom_action_type
resource "aws_codepipeline_custom_action_type" "this" {
  for_each = {
    for idx, key in var.pipeline_custom_actions : idx => {
      category                = key.category
      provider_name           = key.provider_name
      version                 = key.version
      input_artifact_details  = key.input_artifact_details
      output_artifact_details = key.output_artifact_details
      configuration_property  = try(key.configuration_property, {})
      settings                = try(key.settings, {})
    }
    if var.pipeline_custom_actions != []
  }

  category      = each.value.category
  provider_name = each.value.provider_name
  version       = each.value.version

  input_artifact_details {
    minimum_count = each.value.input_artifact_details.minimum_count
    maximum_count = each.value.input_artifact_details.maximum_count
  }

  output_artifact_details {
    minimum_count = each.value.output_artifact_details.minimum_count
    maximum_count = each.value.output_artifact_details.maximum_count
  }

  settings {
    entity_url_template           = try(each.value.settings.entity_url_template, null)
    execution_url_template        = try(each.value.settings.execution_url_template, null)
    revision_url_template         = try(each.value.settings.revision_url_template, null)
    third_party_configuration_url = try(each.value.settings.third_party_configuration_url, null)
  }

  ### This property must be provided in all CustomActionType for job query API calls
  configuration_property {
    name        = "PipelineName"
    description = "CodePipeline name to pass into the Custom Action"
    queryable   = true
    required    = true
    key         = false
    secret      = false
    type        = "String"
  }

  dynamic "configuration_property" {
    for_each = try(each.value.configuration_property, [])

    content {
      name        = configuration_property.value.name
      key         = configuration_property.value.key
      required    = configuration_property.value.required
      secret      = configuration_property.value.secret
      description = try(configuration_property.value.description, null)
      queryable   = try(configuration_property.value.queryable, null)
      type        = try(configuration_property.value.type, null)
    }
  }

  tags = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook
resource "aws_codepipeline_webhook" "this" {
  count = var.create_pipeline != false && var.pipeline_webhook != {} ? 1 : 0

  name            = var.pipeline_webhook.name
  authentication  = var.pipeline_webhook.authentication
  target_pipeline = aws_codepipeline.this[0].name
  target_action   = var.pipeline_webhook.target_action

  dynamic "filter" {
    for_each = var.pipeline_webhook.filter

    content {
      json_path    = filter.value.json_path
      match_equals = filter.value.match_equals
    }
  }

  dynamic "authentication_configuration" {
    for_each = try(var.pipeline_webhook.auth_configs, {}) != {} ? [true] : []

    content {
      allowed_ip_range = try(var.pipeline_webhook.auth_configs.allowed_ip_range, null)
      secret_token     = try(var.pipeline_webhook.auth_configs.secret_token, null)
    }
  }

  tags       = var.tags
  depends_on = [aws_codepipeline.this]
}

# CodePipeline notification rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
resource "aws_codestarnotifications_notification_rule" "this" {
  count = var.codepipeline_notifications != {} && var.create_pipeline != false ? 1 : 0

  status   = "ENABLED"
  resource = aws_codepipeline.this[0].arn
  name     = "${var.codepipeline_basic.name}-notification-rule"

  detail_type    = var.codepipeline_notifications.detail_type
  event_type_ids = var.codepipeline_notifications.event_type_ids

  dynamic "target" {
    for_each = var.codepipeline_notifications.targets

    content {
      address = target.value.address
      type    = try(target.value.type, "SNS")
    }
  }
  tags       = var.tags
  depends_on = [aws_codepipeline.this]
}


####################################
# Supporting Resources
####################################
resource "aws_iam_role" "this" {
  count = var.create_pipeline_role != false && var.create_pipeline != false ? 1 : 0

  name        = var.pipeline_role_name
  description = var.pipeline_role_description
  tags = merge(
    var.tags,
    {
      default = "module_aws_cicd"
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
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
  inline_policy {
    name   = "default-cicd-policy"
    policy = var.pipeline_role_policy
  }
}
