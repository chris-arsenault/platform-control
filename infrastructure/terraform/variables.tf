data "aws_ssm_parameter" "github_pat" {
  name = "/platform/control/github-pat"
}

locals {
  github_pat = nonsensitive(data.aws_ssm_parameter.github_pat.value)
}
