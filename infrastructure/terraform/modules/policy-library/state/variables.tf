variable "prefix" {
  description = "Prefix for all boilerplate"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "state_key_prefix" {
  description = "S3 key prefix this project is allowed to write state under"
  type        = string
}
