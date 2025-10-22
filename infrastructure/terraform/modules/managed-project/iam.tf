locals {

  allowed_repos = [for r in var.allowed_repos : "chris-arsenault/${r}"]
  branch_subs = flatten([
    for r in local.allowed_repos : [
      for b in var.allowed_branches : "repo:${r}:ref:refs/heads/${b}"
    ]
  ])
  pull_request_subs = flatten([
    for r in local.allowed_repos : var.allow_pull_request ? ["repo:${r}:pull_request"] : []
  ])
  # Build allowed 'sub' claims for refs, envs, and optionally PR runs:
  # - repo:OWNER/REPO:ref:refs/heads/<branch>
  # - repo:OWNER/REPO:environment:<env>
  # - repo:OWNER/REPO:pull_request
  allowed_subs = concat(
    local.branch_subs,
    local.pull_request_subs
  )
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = length(local.allowed_subs) > 0 ? local.allowed_subs : ["repo:UNKNOWN/*"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "deployer-${var.prefix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags               = local.tags
  path               = "/${var.prefix}/"
}

resource "aws_iam_role_policy" "inline_modules" {
  for_each = var.policy_modules
  role     = aws_iam_role.this.id
  name     = each.value
  policy   = local.policy_map[each.value]
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role = aws_iam_role.this.id
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}