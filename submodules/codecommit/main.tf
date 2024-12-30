### AWS CodeCommit ###
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository
resource "aws_codecommit_repository" "this" {
  count = var.create_codecommit_repo != false ? 1 : 0

  repository_name = var.codecommit_repo_name
  description     = try(var.codecommit_repo_description, null)
  default_branch  = try(var.codecommit_repo_default_branch, null)
  tags            = var.tags
}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template
resource "aws_codecommit_approval_rule_template" "this" {
  count = var.create_codecommit_repo != false && var.enable_repo_approval != false ? 1 : 0

  name        = "${var.codecommit_repo_name}-${var.codecommit_repo_default_branch}"
  description = "CodeCommit repository Approval rule template"

  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = ["refs/heads/${var.codecommit_repo_default_branch}"]
    Statements = [{
      Type                    = "Approvers"
      NumberOfApprovalsNeeded = var.number_of_approvers
      ApprovalPoolMembers     = var.codecommit_repo_approvers
    }]
  })

  depends_on = [aws_codecommit_repository.this]
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_approval_rule_template_association
resource "aws_codecommit_approval_rule_template_association" "this" {
  count = var.create_codecommit_repo != false && var.enable_repo_approval != false ? 1 : 0

  repository_name             = aws_codecommit_repository.this[0].repository_name
  approval_rule_template_name = aws_codecommit_approval_rule_template.this[0].name

  depends_on = [aws_codecommit_repository.this, aws_codecommit_approval_rule_template.this]
}

### NOTE:
# Terraform currently can create only one trigger per repository
# even if multiple aws_codecommit_trigger resources are defined.
# Moreover, creating triggers with Terraform will delete all other triggers
# in the repository (also manually-created triggers).
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_trigger
resource "aws_codecommit_trigger" "this" {
  count = var.create_codecommit_repo != false && var.create_repo_trigger != false ? 1 : 0

  repository_name = aws_codecommit_repository.this[0].repository_name

  trigger {
    name            = "${var.codecommit_repo_name}-trigger"
    events          = var.trigger_events
    branches        = var.trigger_on_all_branches != false ? null : ["${var.codecommit_repo_default_branch}"]
    destination_arn = var.repo_trigger_destination
  }

  depends_on = [aws_codecommit_repository.this]
}

# CodeCommit notification rules
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule
resource "aws_codestarnotifications_notification_rule" "this" {
  count = var.codecommit_notifications != {} && var.create_codecommit_repo != false ? 1 : 0

  status   = "ENABLED"
  resource = aws_codecommit_repository.this[0].arn
  name     = "${var.codecommit_repo_name}-notification-rule"

  detail_type    = var.codecommit_notifications.detail_type
  event_type_ids = var.codecommit_notifications.event_type_ids

  dynamic "target" {
    for_each = var.codecommit_notifications.targets

    content {
      address = target.value.address
      type    = try(target.value.type, "SNS")
    }
  }
  tags       = var.tags
  depends_on = [aws_codecommit_repository.this]
}
