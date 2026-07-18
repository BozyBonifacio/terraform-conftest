# Terraform shift-left policy checks

A minimal, credential-free example that evaluates a real Terraform plan JSON with [Conftest](https://www.conftest.dev/) and OPA/Rego before infrastructure changes can merge.

## What the policy enforces

- Every `terraform_data` resource has a non-empty `input.owner`.
- `input.environment` is one of `development`, `staging`, or `production`.
- Destructive resource changes are rejected unless the policy is deliberately changed.

The demo uses the built-in `terraform_data` resource, so neither cloud credentials nor provider downloads are required.

## Run locally

Install Terraform 1.6+ and Conftest 0.62+, then run:

```bash
make policy
make test
```

This creates a saved plan, converts it with `terraform show -json`, and evaluates `plan.json` under `policy/`.

## Test it with a pull request

Create a branch and deliberately change `main.tf` from:

```hcl
environment = "development"
```

to:

```hcl
environment = "sandbox"
```

Push the branch and open a PR. The **Terraform policy** check will fail with:

```text
terraform_data.application input.environment must be development, staging, or production
```

Change it back to an allowed value and push again; the check will pass. For production use, replace the demo rules with policies for your actual provider resources and make this workflow a required branch-protection check.

