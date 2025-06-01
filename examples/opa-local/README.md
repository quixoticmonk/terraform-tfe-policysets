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

The example includes an OPA policy that restricts EC2 instance types to only allow t2.micro and t3.micro instances.

### restrict_instance_type.rego

This policy checks all AWS EC2 instances in the Terraform plan and ensures they use only the allowed instance types.

```rego
# restrict_instance_type.rego
package terraform.policies

import input.tfplan as tfplan

# Deny rule for non-compliant instances
deny[msg] {
    resource := tfplan.resource_changes[_]
    resource.type == "aws_instance"
    resource.change.after.instance_type not in ["t2.micro", "t3.micro"]
    
    msg := sprintf(
        "Instance type %s is not allowed. Use t2.micro or t3.micro instead.",
        [resource.change.after.instance_type]
    )
}
```

## Notes

- Replace `my-org` with your actual HCP Terraform organization name
- Replace the workspace IDs with your actual workspace IDs
- You can add more OPA policies to the `policies` directory as needed
- OPA policies run as agent-enabled policies by default
