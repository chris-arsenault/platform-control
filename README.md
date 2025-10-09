# AWS Account Control Plane (Terraform + GitHub OIDC)

This stack creates:
- A GitHub OIDC provider in AWS
- A Terraform **deployment role** assumed by GitHub Actions via OIDC
- A reusable module to add **project deployment roles** with least-privilege
- A single GitHub Actions workflow (`deploy.yml`) that plans/applies this stack

## Quick start

1) Create a new, empty GitHub repo and push this project.

2) In `terraform/variables.tf`, set:
    - `aws_account_id`
    - `aws_region`
    - `github_owner`
    - `deployment_repo` (repo running this stack, e.g. `my-org/aws-control-plane-terraform`)

3) Optional: configure remote state in `terraform/backend.tf` (S3 + DynamoDB) or comment it out to use local state while bootstrapping.

4) Commit & push to `main`. The included GitHub Action will:
    - Obtain an OIDC token
    - Assume the Terraform **deployment role**
    - Run `terraform init/plan/apply`

## Adding project roles

Edit `terraform/main.tf` and add more `module "project_role_*"` blocks with:
- `role_name`
- `policy_arns` or `inline_policies`
- `allowed_repos` / `allowed_branches` or `allowed_environments`

These roles will be assumable by GitHub Actions in those repos via OIDC (no long-lived AWS keys).

## Notes

- The default GitHub OIDC thumbprint is set to `6938fd4d98bab03faadb97b34396831e3780aea1`. Override via `var.oidc_thumbprints` if GitHub rotates certs.
- The deployment role is scoped to manage IAM roles that match `var.role_name_prefix` (default: `project-`) to keep permissions tight.
