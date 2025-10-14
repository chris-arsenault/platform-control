
locals {
  deployment_role_name                         = "deployer-${var.prefix}"
  project_guardrails_permissions_boundary_name = "pb-${var.prefix}-project-guardrails"
  project_boundary_arn = "arn:aws:iam::${var.account_id}:policy/${local.project_guardrails_permissions_boundary_name}"

  # Common ARNs
  prefixed_roles_arn       = "arn:aws:iam::${var.account_id}:role/deployer-*"
  permissions_boundary_arn = "arn:aws:iam::${var.account_id}:policy/pb-*"
}