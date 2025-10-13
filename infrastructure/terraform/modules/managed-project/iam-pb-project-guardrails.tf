data "aws_iam_policy_document" "pb_project_guardrails" {
  statement {
    sid       = "AllowOtherThings"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }

  # Hard no on Users/Groups
  statement {
    sid       = "DenyUsers"
    effect    = "Deny"
    actions   = ["iam:*"]
    resources = [local.all_users_arn]
  }
  statement {
    sid       = "DenyGroups"
    effect    = "Deny"
    actions   = ["iam:*"]
    resources = [local.all_groups_arn]
  }

  # Require approved boundary on CreateRole
  statement {
    sid       = "DenyCreateRoleWithoutApprovedBoundary"
    effect    = "Deny"
    actions   = ["iam:CreateRole"]
    resources = ["*"]
    condition {
      test     = "StringNotEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.project_boundary_arn]
    }
  }

  # Prevent boundary removal/change unless to the approved boundary
  statement {
    sid    = "DenyBoundaryChangeUnlessApproved"
    effect = "Deny"
    actions = [
      "iam:DeleteRolePermissionsBoundary",
      "iam:PutRolePermissionsBoundary"
    ]
    resources = ["${local.all_roles_arn_prefix}/*"]
    condition {
      test     = "StringNotEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.project_boundary_arn]
    }
  }

  # Allow ceiling for IAM on prefixed roles (so they can create Lambda service roles etc.)
  statement {
    sid    = "AllowRoleAdminOnPrefixedRolesCeiling"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    resources = [local.prefixed_roles_arn]
  }

  # Allow reads everywhere
  statement {
    sid       = "AllowRead"
    effect    = "Allow"
    actions   = ["iam:Get*", "iam:List*", "sts:GetCallerIdentity"]
    resources = ["*"]
  }
}
