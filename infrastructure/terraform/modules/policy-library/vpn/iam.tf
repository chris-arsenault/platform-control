data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowDescribesAndReads"
    actions = [
      "iam:GetRole",
      "iam:ListInstanceProfiles",
      "iam:ListAttachedRolePolicies",
      "iam:GetInstanceProfile",
      "ssm:GetParameter",
      "ssm:DescribeParameter",
      "ssm:DescribeParameters",
      "ssm:GetParameters",
      "ssm:ListTagsForResource"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowAutoscaling"
    actions = [
      "autoscaling:CreateAutoScalingGroup",
    ]
    resources = ["arn:aws:autoscaling:us-east-1:${var.account_id}:autoScalingGroup:*:autoScalingGroupName/${var.prefix}-"]
  }

  statement {
    sid = "CreateNamespacedEc2Resources"
    actions = [
      "ec2:CreateVpc",
      "ec2:CreateSubnet",
      "ec2:CreateInternetGateway",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateNetworkInterface",
      "ec2:AllocateAddress",
      "ec2:RunInstances",
      "ec2:CreateTags",
      "ec2:DisassociateAddress",
      "ec2:CreateLaunchTemplate",
    ]
    resources = ["*"]

    condition {
      test     = "StringEqualsIfExists"
      variable = "aws:RequestTag/project"
      values   = [var.prefix]
    }
  }

  # Require ec2:ResourceTag/project for ops that reference existing resources
  statement {
    sid = "ManageOnlyNamespacedEc2Resources"
    actions = [
      "ec2:AttachInternetGateway",
      "ec2:CreateRoute", # route-table + target must be tagged
      "ec2:ReplaceRoute",
      "ec2:CreateNetworkInterface",
      "ec2:AttachNetworkInterface",
      "ec2:DetachNetworkInterface",
      "ec2:AssociateRouteTable", # route-table + subnet must be tagged
      "ec2:DeleteVpc",
      "ec2:DeleteSubnet",
      "ec2:DeleteInternetGateway",
      "ec2:DetachInternetGateway",
      "ec2:DeleteRouteTable",
      "ec2:DeleteRoute",
      "ec2:DisassociateRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:AssociateAddress", # EIP + ENI/instance must be tagged
      "ec2:DisassociateAddress",
      "ec2:ReleaseAddress",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:TerminateInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:StopInstances",
      "ec2:DeleteNetworkInterface",
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/project"
      values   = [var.prefix]
    }
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
      "iam:TagInstanceProfile",
      "iam:UntagInstanceProfile",
      "iam:TagRole",
      "iam:UntagRole"
    ]
    resources = [
      "arn:aws:iam::*:role/${var.prefix}-*",
      "arn:aws:iam::*:instance-profile/${var.prefix}-*"
    ]
  }

  statement {
    sid       = "PassprojectdRolesToEc2"
    actions   = ["iam:PassRole"]
    resources = ["arn:aws:iam::*:role/${var.prefix}-*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid = "ManageNamespacedSsmParameters"
    actions = [
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:AddTagsToResource",
      "ssm:RemoveTagsFromResource"
    ]
    resources = ["arn:aws:ssm:*:*:parameter/${var.prefix}/*"]
  }

  statement {
    sid = "CreateSecretKeys"
    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:DescribeSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:PutResourcePolicy"
    ]
    resources = ["arn:aws:secretsmanager:*:*:secret:${var.prefix}-*"]
  }
}