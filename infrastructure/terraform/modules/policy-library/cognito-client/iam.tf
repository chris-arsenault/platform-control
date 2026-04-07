data "aws_iam_policy_document" "this" {
  statement {
    sid    = "CognitoClientManagement"
    effect = "Allow"
    actions = [
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:UpdateUserPoolClient",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:DescribeUserPoolClient"
    ]
    resources = ["arn:aws:cognito-idp:*:${var.account_id}:userpool/*"]
  }

  # Publish the client ID to the shared discovery path used by the
  # ahara-tf-patterns cognito-app module, auth-trigger client map, etc.
  # Scoped to /platform/cognito/clients/* so it can only register, not
  # overwrite arbitrary platform SSM params.
  statement {
    sid    = "CognitoClientSsmRegistry"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
      "ssm:ListTagsForResource",
    ]
    resources = [
      "arn:aws:ssm:*:${var.account_id}:parameter/platform/cognito/clients/*",
    ]
  }
}
