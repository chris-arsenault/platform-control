data "aws_iam_policy_document" "this" {
  statement {
    sid    = "LambdaCrud"
    effect = "Allow"
    actions = [
      "lambda:CreateFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:DeleteFunction",
      "lambda:Get*",
      "lambda:PublishVersion",
      "lambda:CreateAlias",
      "lambda:UpdateAlias",
      "lambda:DeleteAlias",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:TagResource"
    ]
    resources = ["arn:aws:lambda:*:${var.account_id}:function:${var.prefix}-*"]
  }

  # These list operations do not support resource-level permissions.
  statement {
    sid    = "LambdaList"
    effect = "Allow"
    actions = [
      "lambda:ListVersionsByFunction",
      "lambda:ListAliases"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "PassRoleToLambda"
    effect  = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${var.prefix}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["lambda.amazonaws.com"]
    }
  }

  statement {
    sid    = "ApiGatewayCrud"
    effect = "Allow"
    actions = [
      "apigateway:GET",
      "apigateway:POST",
      "apigateway:PUT",
      "apigateway:PATCH",
      "apigateway:DELETE"
    ]
    resources = [
      "arn:aws:apigateway:us-east-1::/apis/*",
      "arn:aws:apigateway:us-east-1::/restapis/*"
    ]
  }

  statement {
    sid     = "AttachBasicExecPolicy"
    effect  = "Allow"
    actions = ["iam:AttachRolePolicy"]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${var.prefix}-*"
    ]
    condition {
      test     = "ArnEquals"
      variable = "iam:PolicyARN"
      values   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
    }
  }
}
