data "aws_iam_policy_document" "pb_control_plane" {
  statement {
    sid       = "AllowOtherThings"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }

  # ---- GLOBAL HARD DENIES ----
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

  # Require the approved permissions boundary on CreateRole
  # (CreateRole is not resource-scoped; use condition key)
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

  # Prevent removing/changing role boundaries except to the approved project boundary
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

  # Optional defense-in-depth: restrict which managed policies can be attached to prefixed roles
  statement {
    sid       = "DenyAttachUnapprovedManagedPoliciesToPrefixedRoles"
    effect    = "Deny"
    actions   = ["iam:AttachRolePolicy"]
    resources = [local.prefixed_roles_arn]
    condition {
      test     = "StringNotEquals"
      variable = "iam:PolicyARN"
      values   = local.allowed_managed_policy_arns
    }
  }

  # ---- ALLOW CAP (remember: actual Allows come from the role policy) ----
  statement {
    sid       = "AllowRead"
    effect    = "Allow"
    actions   = ["iam:Get*", "iam:List*", "sts:GetCallerIdentity"]
    resources = ["*"]
  }

  # Let the pipeline author policies it needs
  statement {
    sid       = "AllowCreatePolicies"
    effect    = "Allow"
    actions   = ["iam:CreatePolicy"]
    resources = ["*"]
  }

  # Allow boundary set to approved boundary on prefixed roles
  statement {
    sid       = "AllowSetApprovedBoundaryOnPrefixedRoles"
    effect    = "Allow"
    actions   = ["iam:PutRolePermissionsBoundary"]
    resources = [local.prefixed_roles_arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.project_boundary_arn]
    }
  }

  # Cap: allow doing IAM on prefixed roles (create/update/etc.) — ceiling only
  statement {
    sid    = "AllowRoleAdminOnPrefixedRolesCap"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole", # boundary above still prevents removing boundary to sidestep
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    resources = [local.deployer_roles_arn]
  }
}