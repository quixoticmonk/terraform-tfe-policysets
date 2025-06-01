# OPA Local Policy Example

This example demonstrates how to use the Terraform Policy Set module to upload OPA policies from a local directory.

## Usage

```bash
terraform init
terraform apply
```

## Requirements

- Terraform >= 1.0.0
- hashicorp/tfe provider >= 0.40.0
- Valid HCP Terraform organization and workspace IDs

## Policy Details

The example includes one OPA policy that prevents deployments on Fridays.

### no_friday_deploys.rego

This policy prevents any deployments from occurring on Fridays.

```rego
# no_friday_deploys.rego
package terraform.policies.no_friday_deploys

# Deny rule for deployments on Friday
deny[msg] {
    # Get the current day of the week as a string
    day := time.weekday(time.now_ns())
    day == "Friday"
    
    msg := sprintf(
        "Deployments are not allowed on Fridays. Please try again on another day.",
        []
    )
}
```

## Notes

- Replace `my-org` with your actual HCP Terraform organization name
- Replace the workspace IDs with your actual workspace IDs
- You can add more OPA policies to the `policies` directory as needed
- OPA policies run as agent-enabled policies by default
