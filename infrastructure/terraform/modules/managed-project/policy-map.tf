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

module "reverse-proxy" {
  source     = "../policy-library/reverse-proxy"
  prefix     = var.prefix
  account_id = var.account_id
}

module "state" {
  source           = "../policy-library/state"
  prefix           = var.prefix
  account_id       = var.account_id
  state_key_prefix = var.state_key_prefix
}

module "static-website" {
  source     = "../policy-library/static-website"
  prefix     = var.prefix
  account_id = var.account_id
}

module "vpn" {
  source     = "../policy-library/vpn"
  prefix     = var.prefix
  account_id = var.account_id
}

module "platform-services" {
  source     = "../policy-library/platform-services"
  prefix     = var.prefix
  account_id = var.account_id
}

module "cognito-client" {
  source     = "../policy-library/cognito-client"
  prefix     = var.prefix
  account_id = var.account_id
}


locals {
  policy_map = {
    "api"               = module.api.policy_json
    "bedrock"           = module.bedrock.policy_json
    "cognito-client"    = module.cognito-client.policy_json
    "control-plane"     = module.control-plane.policy_json
    "iam"               = module.iam.policy_json
    "state"             = module.state.policy_json
    "reverse-proxy"     = module.reverse-proxy.policy_json
    "static-website"    = module.static-website.policy_json
    "vpn"               = module.vpn.policy_json
    "platform-services" = module.platform-services.policy_json
  }
}