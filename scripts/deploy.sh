#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${ROOT_DIR}/infrastructure/terraform"

STATE_BUCKET="${STATE_BUCKET:-tfstate-559098897826}"
STATE_REGION="${STATE_REGION:-us-east-1}"
GITHUB_PAT="${GITHUB_PAT:?GITHUB_PAT must be set}"

# --- Ensure shared state bucket exists ---

if ! aws s3api head-bucket --bucket "${STATE_BUCKET}" 2>/dev/null; then
  echo "Creating state bucket: ${STATE_BUCKET}"
  aws s3api create-bucket --bucket "${STATE_BUCKET}" --region "${STATE_REGION}"

  aws s3api put-bucket-versioning --bucket "${STATE_BUCKET}" \
    --versioning-configuration Status=Enabled

  aws s3api put-bucket-encryption --bucket "${STATE_BUCKET}" \
    --server-side-encryption-configuration '{
      "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
    }'

  aws s3api put-public-access-block --bucket "${STATE_BUCKET}" \
    --public-access-block-configuration \
      BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

  aws s3api put-bucket-policy --bucket "${STATE_BUCKET}" \
    --policy "{
      \"Version\": \"2012-10-17\",
      \"Statement\": [
        {
          \"Sid\": \"DenyBareStateKeys\",
          \"Effect\": \"Deny\",
          \"Principal\": \"*\",
          \"Action\": \"s3:PutObject\",
          \"Resource\": [
            \"arn:aws:s3:::${STATE_BUCKET}/terraform.tfstate\",
            \"arn:aws:s3:::${STATE_BUCKET}/.terraform.lock.hcl\"
          ]
        }
      ]
    }"
fi

# --- Terraform ---

terraform -chdir="${TF_DIR}" init \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="region=${STATE_REGION}" \
  -backend-config="use_lockfile=true"

terraform -chdir="${TF_DIR}" apply -auto-approve \
  -var "github_pat=${GITHUB_PAT}"
