# Enterprise Cloud Guardrails Engine (Policy-as-Code)

A automated **Shift-Left Policy-as-Code** framework using **Open Policy Agent (OPA)** and **GitHub Actions**. This engine intercepts Terraform execution plans during Pull Request reviews, evaluating prospective cloud infrastructure against enterprise compliance and security standards before deployment.

---

## Architecture Overview

```text
[ Developer PR ] 
       │
       ▼
[ GitHub Actions Pipeline ]
   ├── 1. Run Rego Unit Tests (`opa test`)
   ├── 2. Generate Plan JSON (`terraform plan -out` ──► `terraform show -json`)
   └── 3. OPA Guardrail Evaluation (`opa eval`)
           ├── PASS ──► [ PR Permitted to Merge ]
           └── FAIL ──► [ Pipeline Blocked & Line-Item Violations Logged ]