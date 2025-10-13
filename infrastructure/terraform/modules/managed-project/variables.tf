variable "prefix" {
  description = "Prefix for all boilerplate"
  type        = string
}

variable "project_prefix" {
  description = "Prefix for just this role"
  type        = string
}

variable "oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  type        = string
}

variable "allowed_repos" {
  description = "List of GitHub repos (owner/repo) allowed to assume this role"
  type        = set(string)
}

variable "allowed_branches" {
  description = "Allowed branch globs (e.g., main, release/*)"
  type        = set(string)
}

variable "allowed_environments" {
  description = "Optional list of GitHub environments permitted to assume the role"
  type        = set(string)
  default     = []
}

variable "allow_pull_request" {
  description = "Allow GitHub Actions OIDC tokens issued for pull_request events."
  type        = bool
  default     = false
}

variable "policy_arns" {
  description = "Managed policy ARNs to attach"
  type        = set(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of name -> policy JSON strings to attach inline"
  type        = map(string)
  default     = {}
}

variable "policy_modules" {
  description = "List of policy modules to provision"
  type        = set(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "Permissions boundary ARN to apply to this role"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the role"
  type        = map(string)
  default     = { ManagedBy = "terraform" }
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "github_pat" {
  type        = string
  description = "Github PAT for writing github secrets"
}
