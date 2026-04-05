data "aws_iam_policy_document" "this" {
  statement {
    sid    = "InvokeKomodoProxy"
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction"
    ]
    resources = [
      "arn:aws:lambda:*:${var.account_id}:function:platform-komodo-proxy",
      "arn:aws:lambda:*:${var.account_id}:function:platform-db-migrate-truenas",
      "arn:aws:lambda:*:${var.account_id}:function:nas-sonarqube-ci-token"
    ]
  }
}
