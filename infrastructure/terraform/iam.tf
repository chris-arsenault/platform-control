# data "aws_iam_policy_document" "assume_by_github_deployment_repo" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Federated"
#       identifiers = [aws_iam_openid_connect_provider.github.arn]
#     }
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#
#     # Constrain to the specific repo and branch
#     condition {
#       test     = "StringEquals"
#       variable = "${local.oidc_url}:sub"
#       values   = ["repo:${local.deployment_repo}:ref:refs/heads/main"]
#     }
#
#     # Audience must be sts.amazonaws.com
#     condition {
#       test     = "StringEquals"
#       variable = "${local.oidc_url}:aud"
#       values   = ["sts.amazonaws.com"]
#     }
#   }
# }
#
# resource "aws_iam_role" "tf_deploy_role" {
#   name               = local.deployment_role_name
#   assume_role_policy = data.aws_iam_policy_document.assume_by_github_deployment_repo.json
#
#   permissions_boundary = aws_iam_policy.pb_control_plane.arn
# }
#
# resource "aws_iam_policy" "deploy_policy" {
#   name        = "tf-deploy-manage-iam"
#   description = "Manage OIDC + IAM roles with prefix ${local.prefix}* and maintain self"
#   policy      = data.aws_iam_policy_document.deploy_manage_iam.json
# }
#
# resource "aws_iam_role_policy_attachment" "deploy_attach" {
#   role       = aws_iam_role.tf_deploy_role.name
#   policy_arn = aws_iam_policy.deploy_policy.arn
# }