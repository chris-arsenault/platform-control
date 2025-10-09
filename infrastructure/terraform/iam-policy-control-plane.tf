# Policy that lets the deployment role:
# - manage IAM roles whose name begins with var.role_name_prefix
# - manage this exact deployment role (for drift fixes), but not delete it
data "aws_iam_policy_document" "deploy_manage_iam" {
  statement {
    sid    = "AllAccountStateManagment"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:PutBucketVersioning",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketPublicAccessBlock",
      "s3:Get*",
    ]
    resources = [
      "arn:aws:s3:::tf-state-*",
    ]
  }

  statement {
    sid    = "AllAccountStateLock"
    effect = "Allow"
    actions = [
      "dynamodb:CreateTable",
      "dynamodb:Describe*",
      "dynamodb:List*",
    ]
    resources = [
      "arn:aws:dynamodb:*:*:table/tf-lock-*"
    ]
  }

  statement {
    sid    = "ManagePrefixedRoles"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies",
      "iam:ListInstanceProfilesForRole"
    ]
    resources = [
      "arn:aws:iam::${local.account_id}:role/${local.prefix}*"
    ]
  }

  statement {
    sid    = "ManageOIDCProvider"
    effect = "Allow"
    actions = [
      "iam:CreateOpenIDConnectProvider",
      "iam:DeleteOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:TagOpenIDConnectProvider",
      "iam:UntagOpenIDConnectProvider",
      "iam:GetOpenIDConnectProvider",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:RemoveClientIDFromOpenIDConnectProvider"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ReadOnlyDescribe"
    effect = "Allow"
    actions = [
      "iam:List*",
      "iam:Get*",
      "sts:GetCallerIdentity"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ManageSelfRolePolicy"
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    resources = ["arn:aws:iam::${local.account_id}:role/${local.deployment_role_name}"]
  }

  statement {
    sid       = "DenyDeleteSelf"
    effect    = "Deny"
    actions   = ["iam:DeleteRole"]
    resources = ["arn:aws:iam::${local.account_id}:role/${local.deployment_role_name}"]
  }

  # Allow create/modify prefixed roles; the boundary above still enforces guardrails
  statement {
    sid    = "AllowPrefixedRoleWork"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:PutRolePermissionsBoundary",
      "iam:PassRole",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListRolePolicies"
    ]
    resources = [local.prefixed_roles_arn]
  }

  # Allow setting only the approved boundary to prefixed roles
  statement {
    sid       = "AllowSetApprovedBoundary"
    effect    = "Allow"
    actions   = ["iam:PutRolePermissionsBoundary"]
    resources = [local.prefixed_roles_arn]
    condition {
      test     = "StringEquals"
      variable = "iam:PermissionsBoundary"
      values   = [local.project_boundary_arn]
    }
  }

  # Allow creating policies needed by deployments
  statement {
    sid       = "AllowCreatePolicies"
    effect    = "Allow"
    actions   = ["iam:CreatePolicy"]
    resources = ["*"]
  }

}
