### AWS CodeDeploy ###
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app
resource "aws_codedeploy_app" "this" {
  count = var.create_codedeploy_application != false && var.codedeploy_application != {} ? 1 : 0

  name             = var.codedeploy_application.name
  compute_platform = var.codedeploy_application.platform
  tags             = var.tags
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_config
resource "aws_codedeploy_deployment_config" "this" {
  count = var.custom_codedeploy_deployment_config != {} ? 1 : 0

  deployment_config_name = var.custom_codedeploy_deployment_config.name
  compute_platform       = try(var.custom_codedeploy_deployment_config.platform, null)

  dynamic "minimum_healthy_hosts" {
    for_each = try(var.custom_codedeploy_deployment_config.min_healthy_hosts, {}) != {} ? [true] : []

    content {
      type  = var.custom_codedeploy_deployment_config.min_healthy_hosts.type
      value = var.custom_codedeploy_deployment_config.min_healthy_hosts.value
    }
  }

  dynamic "traffic_routing_config" {
    for_each = try(var.custom_codedeploy_deployment_config.traffic_routing, {}) != {} ? [true] : []

    content {
      type = try(var.custom_codedeploy_deployment_config.traffic_routing.type, null)

      dynamic "time_based_canary" {
        for_each = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_canary, null) != null ? [true] : []

        content {
          interval   = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_canary.interval, null)
          percentage = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_canary.percentage, null)
        }
      }

      dynamic "time_based_linear" {
        for_each = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_linear, null) != null ? [true] : []

        content {
          interval   = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_linear.interval, null)
          percentage = try(var.custom_codedeploy_deployment_config.traffic_routing.time_based_linear.percentage, null)
        }
      }
    }
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group
resource "aws_codedeploy_deployment_group" "this" {
  count = var.create_codedeploy_application != false && var.create_codedeploy_deployment_group != false ? 1 : 0

  app_name                    = aws_codedeploy_app.this[0].name
  deployment_group_name       = var.codedeploy_deployment_group_name
  service_role_arn            = var.create_codedeploy_deployment_role != false ? aws_iam_role.this[0].arn : var.codedeploy_deployment_role_arn
  autoscaling_groups          = try(var.codedeploy_deployment_group_autoscaling_groups, [])
  deployment_config_name      = var.use_custom_deployment_config != false ? aws_codedeploy_deployment_config.this[0].id : try(var.codedeploy_deployment_group_deployment_config_name, null)
  outdated_instances_strategy = try(var.codedeploy_deployment_group_outdated_instances_strategy, null)

  dynamic "alarm_configuration" {
    for_each = try(var.codedeploy_deployment_group_alarm_configuration, null) != null ? [true] : []

    content {
      alarms                    = try(var.codedeploy_deployment_group_alarm_configuration.alarm, null)
      enabled                   = try(var.codedeploy_deployment_group_alarm_configuration.enabled, null)
      ignore_poll_alarm_failure = try(var.codedeploy_deployment_group_alarm_configuration.ignore_poll_alarm_failure, null)
    }
  }

  dynamic "auto_rollback_configuration" {
    for_each = try(var.codedeploy_deployment_group_auto_rollback_configuration, null) != null ? [true] : []

    content {
      enabled = try(var.codedeploy_deployment_group_auto_rollback_configuration.enabled, null)
      events  = try(var.codedeploy_deployment_group_auto_rollback_configuration.events, null)
    }
  }

  dynamic "blue_green_deployment_config" {
    for_each = try(var.codedeploy_deployment_group_blue_green_deployment_config, null) != null ? [true] : []

    content {
      dynamic "deployment_ready_option" {
        for_each = try(var.codedeploy_deployment_group_blue_green_deployment_config.deployment_ready_option, null) != null ? [true] : []

        content {
          action_on_timeout    = try(var.codedeploy_deployment_group_blue_green_deployment_config.deployment_ready_option.action_on_timeout, null)
          wait_time_in_minutes = try(var.codedeploy_deployment_group_blue_green_deployment_config.deployment_ready_option.wait_time_in_minutes, null)
        }
      }

      dynamic "green_fleet_provisioning_option" {
        for_each = try(var.codedeploy_deployment_group_blue_green_deployment_config.green_fleet_provisioning_option, null) != null ? [true] : []

        content {
          action = try(var.codedeploy_deployment_group_blue_green_deployment_config.green_fleet_provisioning_option.action, null)
        }
      }

      dynamic "terminate_blue_instances_on_deployment_success" {
        for_each = try(var.codedeploy_deployment_group_blue_green_deployment_config.terminate_blue_instances_on_deployment_success, null) != null ? [true] : []

        content {
          action                           = try(var.codedeploy_deployment_group_blue_green_deployment_config.terminate_blue_instances_on_deployment_success.action, null)
          termination_wait_time_in_minutes = try(var.codedeploy_deployment_group_blue_green_deployment_config.terminate_blue_instances_on_deployment_success.termination_wait_time_in_minutes, null)
        }
      }
    }
  }

  dynamic "deployment_style" {
    for_each = try(var.codedeploy_deployment_group_deployment_style, null) != null ? [true] : []

    content {
      deployment_option = try(var.codedeploy_deployment_group_deployment_style.deployment_option, null)
      deployment_type   = try(var.codedeploy_deployment_group_deployment_style.deployment_type, null)
    }
  }

  dynamic "ec2_tag_set" {
    for_each = var.codedeploy_deployment_group_ec2_tag_set != [] ? [true] : []

    content {
      dynamic "ec2_tag_filter" {
        for_each = var.codedeploy_deployment_group_ec2_tag_set

        content {
          type  = try(ec2_tag_filter.value.type, null)
          key   = try(ec2_tag_filter.value.key, null)
          value = try(ec2_tag_filter.value.value, null)
        }
      }
    }
  }

  dynamic "ec2_tag_filter" {
    for_each = var.codedeploy_deployment_group_ec2_tag_filter

    content {
      type  = try(ec2_tag_filter.value.type, null)
      key   = try(ec2_tag_filter.value.key, null)
      value = try(ec2_tag_filter.value.value, null)
    }
  }

  dynamic "ecs_service" {
    for_each = try(var.codedeploy_deployment_group_ecs_service, null) != null ? [true] : []

    content {
      cluster_name = var.codedeploy_deployment_group_ecs_service.cluster_name
      service_name = var.codedeploy_deployment_group_ecs_service.service_name
    }
  }

  dynamic "load_balancer_info" {
    for_each = try(var.codedeploy_deployment_group_load_balancer_info, null) != null ? [true] : []

    content {
      dynamic "elb_info" {
        for_each = try(var.codedeploy_deployment_group_load_balancer_info.elb_info, null) != null ? [true] : []

        content {
          name = try(var.codedeploy_deployment_group_load_balancer_info.elb_info.name, null)
        }
      }

      dynamic "target_group_info" {
        for_each = try(var.codedeploy_deployment_group_load_balancer_info.target_group_info, null) != null ? [true] : []

        content {
          name = try(var.codedeploy_deployment_group_load_balancer_info.target_group_info.name, null)
        }
      }

      dynamic "target_group_pair_info" {
        for_each = try(var.codedeploy_deployment_group_load_balancer_info.target_group_pair_info, null) != null ? [true] : []

        content {
          prod_traffic_route {
            listener_arns = var.codedeploy_deployment_group_load_balancer_info.target_group_pair_info.prod_traffic_route.listener_arns
          }

          dynamic "target_group" {
            for_each = var.codedeploy_deployment_group_load_balancer_info.target_group_pair_info.target_group

            content {
              name = target_group.value.name
            }
          }

          dynamic "test_traffic_route" {
            for_each = try(var.codedeploy_deployment_group_load_balancer_info.target_group_pair_info.test_traffic_route, null) != null ? [true] : []

            content {
              listener_arns = var.codedeploy_deployment_group_load_balancer_info.target_group_pair_info.test_traffic_route.listener_arns
            }
          }
        }
      }
    }
  }

  dynamic "on_premises_instance_tag_filter" {
    for_each = try(var.codedeploy_deployment_group_on_premises_instance_tag_filter, null) != null ? [true] : []

    content {
      type  = try(var.codedeploy_deployment_group_on_premises_instance_tag_filter.type, null)
      key   = try(var.codedeploy_deployment_group_on_premises_instance_tag_filter.key, null)
      value = try(var.codedeploy_deployment_group_on_premises_instance_tag_filter.value, null)
    }
  }

  dynamic "trigger_configuration" {
    for_each = try(var.codedeploy_deployment_group_trigger_configuration, null) != null ? [true] : []

    content {
      trigger_name       = var.codedeploy_deployment_group_trigger_configuration.trigger_name
      trigger_events     = var.codedeploy_deployment_group_trigger_configuration.trigger_events
      trigger_target_arn = var.codedeploy_deployment_group_trigger_configuration.trigger_target_arn
    }
  }

  tags       = var.tags
  depends_on = [aws_codedeploy_app.this]
}

# CodeDeploy notification rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
resource "aws_codestarnotifications_notification_rule" "this" {
  count = var.codedeploy_notifications != {} && var.create_codedeploy_application != false ? 1 : 0

  status   = "ENABLED"
  resource = aws_codedeploy_app.this[0].arn
  name     = "${var.codedeploy_application.name}-notification-rule"

  detail_type    = var.codedeploy_notifications.detail_type
  event_type_ids = var.codedeploy_notifications.event_type_ids

  dynamic "target" {
    for_each = var.codedeploy_notifications.targets

    content {
      address = target.value.address
      type    = try(target.value.type, "SNS")
    }
  }
  tags       = var.tags
  depends_on = [aws_codedeploy_app.this]
}


####################################
# Supporting Resources
####################################
resource "aws_iam_role" "this" {
  count = var.create_codedeploy_application != false && var.create_codedeploy_deployment_group != false && var.create_codedeploy_deployment_role != false ? 1 : 0

  name        = var.codedeploy_deployment_role_name
  description = var.codedeploy_deployment_role_description
  tags = merge(
    var.tags,
    {
      default = "submodule_aws_codedeploy"
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
            "codedeploy.amazonaws.com"
          ]
        }
      }
    ]
  })

  inline_policy {
    name   = "default-codedeploy-policy"
    policy = var.codedeploy_deployment_role_policy
  }
}
