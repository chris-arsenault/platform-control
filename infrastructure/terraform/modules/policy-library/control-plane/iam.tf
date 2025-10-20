# Policy that lets the deployment role:
# - manage IAM roles whose name begins with var.role_name_prefix
# - manage this exact deployment role (for drift fixes), but not delete it
data "aws_iam_policy_document" "this" {
  statement {
    sid    = "AllAccountStateManagment"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:ListBucket",
      "s3:PutBucketVersioning",
      "s3:PutBucketTagging",
      "s3:PutEncryptionConfiguration",
      "s3:PutBucketPublicAccessBlock",
      "s3:Get*",
    ]
    resources = [
      "arn:aws:s3:::tf-state-*",
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
      "iam:GetRolePolicy",
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
      "arn:aws:iam::${var.account_id}:role/deployer-*",
      "arn:aws:iam::${var.account_id}:role/*/deployer-*"
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
    resources = ["arn:aws:iam::${var.account_id}:role/${local.deployment_role_name}"]
  }

  statement {
    sid       = "DenyDeleteSelf"
    effect    = "Deny"
    actions   = ["iam:DeleteRole"]
    resources = ["arn:aws:iam::${var.account_id}:role/${local.deployment_role_name}"]
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

  statement {
    sid = "AllowPolicyUpdates"
    effect = "Allow"
    actions = [
      "iam:CreatePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:TagPolicy",
      "iam:DeletePolicyVersion"
    ]
    resources = [local.permissions_boundary_arn]
  }
}
