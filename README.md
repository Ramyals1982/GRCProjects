# DevSecOps OPA Guardrail Engine

Automated Policy-as-Code (PaC) pipeline using Open Policy Agent (OPA), Terraform, and GitHub Actions to enforce security and compliance guardrails before infrastructure is deployed.

## Security & Compliance Guardrails Enforced

1. **Mandatory Tagging:** All S3 buckets must define a `CostCenter` tag.
2. **Server-Side Encryption:** Every S3 bucket must have an associated `aws_s3_bucket_server_side_encryption_configuration` resource.
3. **Public Access Restrictions:** All `aws_s3_bucket_public_access_block` resources must enforce `block_public_acls`, `block_public_policy`, `ignore_public_acls`, and `restrict_public_buckets`.

## Architecture & Pipeline Flow

1. **Pull Request Trigger:** Developer submits infrastructure updates via Git.
2. **Terraform Plan JSON:** GitHub Actions initializes Terraform (`backend=false`) and exports the execution plan as JSON (`tfplan.json`).
3. **OPA Evaluation:** Open Policy Agent evaluates `tfplan.json` against Rego policies located in `opa-guardrail/policies/`.
4. **Automated PR Gate:** Pipeline exits with code `1` and blocks PR merge if compliance violations exist.

## Local Testing

```bash
# Run policy unit tests
opa test opa-guardrail/policies/ -v

# Evaluate local Terraform plan against policies
cd opa-guardrail/terraform
terraform init -backend=false
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json
opa eval --format pretty --data ../policies/ --input tfplan.json "data.terraform.guardrails.deny"