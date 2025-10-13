module "api" {
  source     = "../policy-library/api"
  prefix     = var.prefix
  account_id = var.account_id
}

module "bedrock" {
  source     = "../policy-library/bedrock"
  prefix     = var.prefix
  account_id = var.account_id
}

module "control-plane" {
  source     = "../policy-library/control-plane"
  prefix     = var.prefix
  account_id = var.account_id
}

module "iam" {
  source     = "../policy-library/iam"
  prefix     = var.prefix
  account_id = var.account_id
}

module "state" {
  source     = "../policy-library/state"
  prefix     = var.prefix
  account_id = var.account_id
}

module "static-website" {
  source     = "../policy-library/static-website"
  prefix     = var.prefix
  account_id = var.account_id
}


locals {
  policy_prefix = "${var.prefix}-${var.project_prefix}"

  policy_map = {
    "api"            = module.api.policy_json
    "bedrock"        = module.bedrock.policy_json
    "iam"            = module.iam.policy_json
    "state"          = module.state.policy_json
    "static-website" = module.static-website.policy_json
  }
}