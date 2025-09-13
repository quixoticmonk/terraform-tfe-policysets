# VCS Integration Example

This example demonstrates how to use the policy set module with VCS integration to connect to a private or organization repository.

## Usage

1. Set up your OAuth token in HCP Terraform for the VCS provider
2. Update the variables with your organization and OAuth token ID
3. Run terraform apply

```bash
terraform init
terraform plan -var="organization=my-org" -var="oauth_token_id=ot-abc123"
terraform apply
```

## Features Demonstrated

- VCS integration with GitHub repository
- OAuth token authentication
- Global policy set application
- Sentinel policy framework

## Repository Reference

This example uses the CIS Policy Set repository:
https://github.com/quixoticmonk/policy-library-CIS-Policy-Set-for-AWS-Terraform

The policies will be automatically synced from the `main` branch of this repository.
