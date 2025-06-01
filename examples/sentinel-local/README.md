# Sentinel Local Policy Example

This example demonstrates how to use the Terraform Policy Set module to upload Sentinel policies from a local directory.

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

The example includes a Sentinel policy that restricts EC2 instance types to only allow t2.micro and t3.micro instances.

### restrict-instance-type.sentinel

This policy checks all AWS EC2 instances in the Terraform plan and ensures they use only the allowed instance types.

```hcl
# restrict-instance-type.sentinel
import "tfplan"

# Main rule that requires all EC2 instances to use allowed types
main = rule {
  all tfplan.resources.aws_instance as _, instances {
    all instances as _, instance {
      instance.applied.instance_type in ["t2.micro", "t3.micro"]
    }
  }
}
```

## Notes

- Replace `my-org` with your actual HCP Terraform organization name
- Replace the workspace IDs with your actual workspace IDs
- You can add more Sentinel policies to the `policies` directory as needed
