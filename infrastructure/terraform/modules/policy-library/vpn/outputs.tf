output "policy_json" {
  description = "ARN of the policy to allow deployments to do with api gateway"
  value       = data.aws_iam_policy_document.this.json
}