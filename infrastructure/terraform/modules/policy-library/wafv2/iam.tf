data "aws_iam_policy_document" "this" {
  statement {
    sid    = "Wafv2WebAcl"
    effect = "Allow"
    actions = [
      "wafv2:CreateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:UpdateWebACL",
      "wafv2:TagResource",
      "wafv2:UntagResource",
      "wafv2:ListTagsForResource"
    ]
    resources = [
      "arn:aws:wafv2:*:${var.account_id}:regional/webacl/${var.prefix}-*/*",
      "arn:aws:wafv2:*:${var.account_id}:regional/managedruleset/*/*"
    ]
  }

  # Associate/Disassociate require the target resource ARN (ALB, CloudFront, etc.)
  # which cannot be predicted by prefix.
  statement {
    sid    = "Wafv2Associate"
    effect = "Allow"
    actions = [
      "wafv2:AssociateWebACL",
      "wafv2:DisassociateWebACL",
    ]
    resources = ["*"]
  }
}
