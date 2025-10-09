output "policy_json" {
  description = "ARN of the policy to allow deployments to do with api gateway"
  value       = data.aws_iam_policy_document.this.json
}

output "state_bucket" {
  description = "Name of the state bucket to create"
  value       = local.state_bucket
}

output "state_table" {
  description = "Name of the state bucket to create"
  value       = local.state_table
}