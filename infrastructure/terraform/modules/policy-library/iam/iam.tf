data "aws_iam_policy_document" "this" {
  statement {
    sid    = "IAMForRoles"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:DeletePolicyVersion",
      "iam:GetRole",
      "iam:Get*",
      "iam:List*",
      "iam:ListInstanceProfilesForRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:TagPolicy",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy"
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${var.prefix}-*",
      "arn:aws:iam::${var.account_id}:policy/${var.prefix}-*"
    ]
  }
}
