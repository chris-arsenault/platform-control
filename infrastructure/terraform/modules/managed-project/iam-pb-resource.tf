resource "aws_iam_policy" "pb_project_guardrails" {
  name        = local.project_guardrails_permissions_boundary_name
  description = "Boundary for OIDC project roles: deny Users/Groups; require boundary on CreateRole; allow role work on prefixed roles."
  policy      = contains(var.policy_modules, "control-plane") ? data.aws_iam_policy_document.pb_control_plane.json : data.aws_iam_policy_document.pb_project_guardrails.json
}
