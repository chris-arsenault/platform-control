data "aws_iam_policy_document" "this" {
  # --- Cognito ---
  statement {
    sid    = "CognitoUserPool"
    effect = "Allow"
    actions = [
      "cognito-idp:CreateUserPool",
      "cognito-idp:DeleteUserPool",
      "cognito-idp:UpdateUserPool",
      "cognito-idp:DescribeUserPool",
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:UpdateUserPoolClient",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:ListUserPoolClients",
      "cognito-idp:CreateUserPoolDomain",
      "cognito-idp:DeleteUserPoolDomain",
      "cognito-idp:DescribeUserPoolDomain",
      "cognito-idp:UpdateUserPoolDomain",
      "cognito-idp:AdminCreateUser",
      "cognito-idp:AdminDeleteUser",
      "cognito-idp:AdminGetUser",
      "cognito-idp:AdminSetUserPassword",
      "cognito-idp:CreateGroup",
      "cognito-idp:DeleteGroup",
      "cognito-idp:GetGroup",
      "cognito-idp:AdminAddUserToGroup",
      "cognito-idp:AdminRemoveUserFromGroup",
      "cognito-idp:TagResource",
      "cognito-idp:UntagResource"
    ]
    resources = ["arn:aws:cognito-idp:*:${var.account_id}:userpool/*"]
  }

  # --- DynamoDB (platform tables) ---
  statement {
    sid    = "DynamoDB"
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
      "dynamodb:DescribeTimeToLive",
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem",
      "dynamodb:DescribeContinuousBackups"
    ]
    resources = ["arn:aws:dynamodb:*:${var.account_id}:table/${var.prefix}-*"]
  }

  # --- Lambda (platform functions) ---
  statement {
    sid    = "Lambda"
    effect = "Allow"
    actions = [
      "lambda:CreateFunction",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:DeleteFunction",
      "lambda:Get*",
      "lambda:PublishVersion",
      "lambda:AddPermission",
      "lambda:RemovePermission",
      "lambda:TagResource",
      "lambda:ListVersionsByFunction"
    ]
    resources = ["arn:aws:lambda:*:${var.account_id}:function:${var.prefix}-*"]
  }

  statement {
    sid    = "IamPassToLambda"
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      values   = ["lambda.amazonaws.com"]
      variable = "iam:PassedToService"
    }
  }

  # --- SSM Parameters (platform namespace) ---
  statement {
    sid    = "SSMParameters"
    effect = "Allow"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource",
      "ssm:ListTagsForResource"
    ]
    resources = ["arn:aws:ssm:*:${var.account_id}:parameter/${var.prefix}/*"]
  }

  # --- SNS (alarm topics) ---
  statement {
    sid    = "SNS"
    effect = "Allow"
    actions = [
      "sns:CreateTopic",
      "sns:DeleteTopic",
      "sns:GetTopicAttributes",
      "sns:SetTopicAttributes",
      "sns:Subscribe",
      "sns:Unsubscribe",
      "sns:TagResource",
      "sns:UntagResource",
      "sns:ListTagsForResource"
    ]
    resources = ["arn:aws:sns:*:${var.account_id}:${var.prefix}-*"]
  }

  # --- ACM (for Cognito custom domain) ---
  statement {
    sid    = "ACM"
    effect = "Allow"
    actions = [
      "acm:RequestCertificate",
      "acm:DeleteCertificate",
      "acm:DescribeCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:ListTagsForCertificate"
    ]
    resources = ["*"]
  }

  # --- Route53 (DNS records for Cognito domain) ---
  statement {
    sid    = "Route53"
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:GetHostedZone",
      "route53:ListResourceRecordSets",
      "route53:GetChange"
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*",
      "arn:aws:route53:::change/*"
    ]
  }

  # --- Budgets ---
  statement {
    sid    = "Budgets"
    effect = "Allow"
    actions = [
      "budgets:CreateBudget",
      "budgets:DeleteBudget",
      "budgets:ModifyBudget",
      "budgets:ViewBudget"
    ]
    resources = ["*"]
  }

  # --- Cost Explorer anomaly detection ---
  statement {
    sid    = "CostExplorer"
    effect = "Allow"
    actions = [
      "ce:CreateAnomalyMonitor",
      "ce:DeleteAnomalyMonitor",
      "ce:GetAnomalyMonitors",
      "ce:UpdateAnomalyMonitor",
      "ce:CreateAnomalySubscription",
      "ce:DeleteAnomalySubscription",
      "ce:GetAnomalySubscriptions",
      "ce:UpdateAnomalySubscription"
    ]
    resources = ["*"]
  }

  # --- IAM (platform-prefixed roles) ---
  statement {
    sid    = "IAMRoles"
    effect = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:GetRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:PutRolePolicy",
      "iam:DeleteRolePolicy",
      "iam:GetRolePolicy",
      "iam:UpdateAssumeRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:GetInstanceProfile"
    ]
    resources = [
      "arn:aws:iam::${var.account_id}:role/${var.prefix}-*",
      "arn:aws:iam::${var.account_id}:instance-profile/${var.prefix}-*"
    ]
  }

  # --- RDS ---
  statement {
    sid    = "RDS"
    effect = "Allow"
    actions = [
      "rds:CreateDBInstance",
      "rds:DeleteDBInstance",
      "rds:ModifyDBInstance",
      "rds:DescribeDBInstances",
      "rds:CreateDBSubnetGroup",
      "rds:DeleteDBSubnetGroup",
      "rds:DescribeDBSubnetGroups",
      "rds:ModifyDBSubnetGroup",
      "rds:AddTagsToResource",
      "rds:RemoveTagsFromResource",
      "rds:ListTagsForResource"
    ]
    resources = [
      "arn:aws:rds:*:${var.account_id}:db:${var.prefix}-*",
      "arn:aws:rds:*:${var.account_id}:subgrp:${var.prefix}-*"
    ]
  }

  # --- EC2 (security groups for RDS) ---
  statement {
    sid    = "EC2SecurityGroups"
    effect = "Allow"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSecurityGroupRules",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowAttachBasicExecPolicy"
    effect = "Allow"
    actions = ["iam:AttachRolePolicy"]
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      values   = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"]
      variable = "iam:PolicyARN"
    }
  }
}
