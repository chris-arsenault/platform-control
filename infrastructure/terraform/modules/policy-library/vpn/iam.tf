data "aws_iam_policy_document" "this" {
  statement {
    sid = "AllowDescribesAndReads"
    actions = [
      "ec2:Describe*",
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
    sid = "CreateNamespacedEc2Resources"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateVpc",
      "ec2:CreateInternetGateway",
      "ec2:CreateRouteTable",
      "ec2:CreateRoute",
      "ec2:AssociateRouteTable",
      "ec2:AllocateAddress",
      "ec2:AssociateAddress",
      "ec2:RunInstances"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/project"
      values   = [var.prefix]
    }

  }

  statement {
    sid     = "TagNewEc2ResourcesIntoNamespace"
    actions = ["ec2:CreateTags"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/project"
      values   = [var.prefix]
    }
  }

  statement {
    sid = "ManageOnlyNamespacedEc2Resources"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateRouteTable",
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
      "ec2:AttachInternetGateway",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:ReleaseAddress",
      "ec2:DisassociateAddress",
      "ec2:TerminateInstances",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyVpcAttribute"
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
}