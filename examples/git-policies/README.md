# Git-Based Policy Set Example

This example demonstrates how to create a policy set in HCP Terraform using policies from a public Git repository.

## Overview

This example:
- Creates a Sentinel policy set using policies from a public GitHub repository
- Applies the policies globally to all workspaces in the organization
- Uses the CIS Policy Set for AWS Terraform as an example policy source

## Usage

```hcl
module "policy_set" {
  source = "../../"

  name              = "cis-policies"
  description       = "Sentinel policies supporting CIS framework"
  organization      = "my-org"
  policy_kind       = "sentinel"
  policy_source     = "git"
  git_url           = "https://github.com/quixoticmonk/policy-library-CIS-Policy-Set-for-AWS-Terraform.git"
  git_branch        = "main"
  git_policies_path = "./"

  # Apply globally to all workspaces
  global = true
}
```

## Requirements

1. An HCP Terraform account with appropriate permissions to create policy sets
2. A valid HCP Terraform API token

## Deployment

1. Configure the HCP Terraform provider with your token:
   ```
   export TFE_TOKEN=your-token-here
   ```

2. Initialize Terraform:
   ```
   terraform init
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

## Notes

- This example uses a public GitHub repository. For private repositories, additional authentication would be required.
- The module will clone the repository to a temporary directory during the Terraform apply process.
- The `git_policies_path` parameter specifies the path within the repository where the policies are located.
