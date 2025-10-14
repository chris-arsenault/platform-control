
locals {
  deployment_role_name                         = "${var.prefix}-deployer"
  project_guardrails_permissions_boundary_name = "${var.prefix}-project-guardrails"
  project_boundary_arn                         = "arn:aws:iam::${var.account_id}:policy/${local.project_guardrails_permissions_boundary_name}"

  # Common ARNs
  prefixed_roles_arn = "arn:aws:iam::${var.account_id}:role/${var.prefix}-*"
  prefixed_policies_arn     = "arn:aws:iam::${var.account_id}:policy/${var.prefix}-*"
}