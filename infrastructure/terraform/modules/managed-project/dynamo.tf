# --- DynamoDB table for state locking ---
resource "aws_dynamodb_table" "tf_lock" {
  count = contains(var.policy_modules, "state") ? 1 : 0

  name         = module.state.state_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}