output "policy_json" {
  description = "IAM policy JSON for scoped state access"
  value       = data.aws_iam_policy_document.this.json
}

output "state_bucket" {
  description = "Name of the shared state bucket"
  value       = local.state_bucket
}
