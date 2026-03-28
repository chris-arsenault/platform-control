data "aws_iam_policy_document" "this" {
  statement {
    sid    = "ApiGatewayV2Crud"
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
    sid    = "LambdaCrudForFunction"
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
    resources = [
      "arn:aws:lambda:*:*:function:${var.prefix}-*",
    ]
  }

  statement {
    sid    = "LambdaReadForFunctionWildcard"
    effect = "Allow"
    actions = [
      "lambda:ListVersionsByFunction",
      "lambda:ListAliases"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "IamPassOnlyLambdaExecRoleToLambda"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      values   = ["lambda.amazonaws.com"]
      variable = "iam:PassedToService"
    }
  }

  statement {
    sid    = "AllowAttachBasicExecPolicy"
    effect = "Allow"
    actions = [
      "iam:AttachRolePolicy"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "ArnEquals"
      values   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
      variable = "iam:PolicyARN"
    }
  }

  statement {
    sid = "CreateAlbResources"
    actions = [
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:CreateRule"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ManageAlbScoped"
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:${var.account_id}:targetgroup/${var.prefix}-*/*",
      "arn:aws:elasticloadbalancing:*:${var.account_id}:listener-rule/app/*/*/*/*/*"
    ]
  }

  statement {
    sid    = "AllowRateLimitDynamo"
    effect = "Allow"
    actions = [
      "dynamodb:CreateTable",
      "dynamodb:DeleteTable",
      "dynamodb:DescribeTable",
      "dynamodb:UpdateTable",
      "dynamodb:TagResource",
      "dynamodb:UntagResource",
      "dynamodb:ListTagsOfResource",
      "dynamodb:UpdateTimeToLive",
      "dynamodb:Get*",
      "dynamodb:Describe*"
    ]
    resources = ["arn:aws:dynamodb:us-east-1:${var.account_id}:table/*rate-limit*"]
  }
}