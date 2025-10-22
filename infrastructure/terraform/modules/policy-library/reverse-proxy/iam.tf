data "aws_iam_policy_document" "this" {
  statement {
    sid = "CreateAlbResources"
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateTargetGroup"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ManageAlbScoped"
    actions = [
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:${var.account_id}:loadbalancer/app/${var.prefix}-*",
      "arn:aws:elasticloadbalancing:*:${var.account_id}:listener/app/${var.prefix}-*/*/*",
      "arn:aws:elasticloadbalancing:*:${var.account_id}:targetgroup/${var.prefix}-*/*"
    ]
  }

  statement {
    sid = "ReadAlb"
    actions = [
      "elasticloadbalancing:SetWebACL",
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "ManageIamForInstanceProfiles"
    actions = [
      "iam:CreateRole",
      "iam:DeleteRole",
      "iam:AttachRolePolicy",
      "iam:DetachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:DeleteInstanceProfile",
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagRole",
      "iam:UntagRole",
    ]
    resources = [
      "arn:aws:iam::*:role/${var.prefix}-*",
      "arn:aws:iam::*:instance-profile/${var.prefix}-*"
    ]
  }

  statement {
    sid    = "IamPassOnlyLambdaExecRoleToLambda"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::*:role/${var.prefix}-*",
    ]
    condition {
      test     = "StringLike"
      values   = ["ec2.amazonaws.com"]
      variable = "iam:PassedToService"
    }
  }

  statement {
    sid = "ManageWaf"
    actions = [
      "wafv2:CreateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:ListTagsForResource",
      "wafv2:TagResource",
      "wafv2:UntagResource",
      "wafv2:UpdateWebACL"
    ]
    resources = [
      "arn:aws:wafv2:*:${var.account_id}:regional/webacl/${var.prefix}-*/*",
      "arn:aws:wafv2:*:${var.account_id}:regional/managedruleset/*/*"
    ]
  }

  statement {
    sid = "AssociateWaf"
    actions = [
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
    ]
    resources = ["*"]
  }

  statement {
    sid = "ManageAcm"
    actions = [
      "acm:AddTagsToCertificate",
      "acm:DeleteCertificate",
      "acm:RemoveTagsFromCertificate",
      "acm:RequestCertificate",
      "acm:UpdateCertificateOptions"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ManageRoute53ForProxy"
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*"
    ]
  }

  statement {
    sid = "ManageCloudFront"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:GetDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:UpdateDistribution",
      "cloudfront:List*",
      "cloudfront:Get*",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:CreateCachePolicy",
      "cloudfront:UpdateCachePolicy",
      "cloudfront:DeleteCachePolicy",
      "cloudfront:CreateOriginRequestPolicy",
      "cloudfront:UpdateOriginRequestPolicy",
      "cloudfront:DeleteOriginRequestPolicy",
    ]
    resources = [
      "arn:aws:cloudfront::${var.account_id}:*"
    ]
  }

  statement {
    sid = "ManageCognitoUserPools"
    actions = [
      "cognito-idp:CreateGroup",
      "cognito-idp:CreateUserPool",
      "cognito-idp:CreateUserPoolClient",
      "cognito-idp:CreateUserPoolDomain",
      "cognito-idp:DeleteGroup",
      "cognito-idp:DeleteUserPool",
      "cognito-idp:DeleteUserPoolClient",
      "cognito-idp:DeleteUserPoolDomain",
      "cognito-idp:DescribeUserPool",
      "cognito-idp:DescribeUserPoolClient",
      "cognito-idp:DescribeUserPoolDomain",
      "cognito-idp:TagResource",
      "cognito-idp:UntagResource",
      "cognito-idp:UpdateGroup",
      "cognito-idp:UpdateUserPool",
      "cognito-idp:UpdateUserPoolClient",
    ]
    resources = [
      "arn:aws:cognito-idp:*:${var.account_id}:userpool/*",
      "arn:aws:cognito-idp:*:${var.account_id}:userpool/*/client/*",
      "arn:aws:cognito-idp:*:${var.account_id}:userpool/*/group/*"
    ]
  }

  statement {
    sid = "ManageCognitoDomains"
    actions = [
      "cognito-idp:CreateUserPoolDomain",
      "cognito-idp:DeleteUserPoolDomain",
    ]
    resources = ["*"]
  }

  statement {
    sid = "EC2Perms"
    actions = [
      "ec2:CreateNatGateway",
      "ec2:DeleteNatGateway"
    ]
    resources = ["*"]
  }

  statement {
    sid = "ManageIdentityPools"
    actions = [
      "cognito-identity:CreateIdentityPool",
      "cognito-identity:DeleteIdentityPool",
      "cognito-identity:DescribeIdentityPool",
      "cognito-identity:GetIdentityPoolRoles",
      "cognito-identity:SetIdentityPoolRoles",
      "cognito-identity:UpdateIdentityPool",
      "cognito-identity:TagResource",
      "cognito-identity:UntagResource"
    ]
    resources = [
      "arn:aws:cognito-identity:*:${var.account_id}:identitypool/*"
    ]
  }

  statement {
    sid       = "CreateReverseProxyInstanceProfile"
    actions   = ["iam:CreateInstanceProfile"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      variable = "iam:InstanceProfileName"
      values   = ["${var.prefix}-*"]
    }
  }
}