# Terraform Policy Set Module

This Terraform module allows you to upload pre-existing Sentinel or OPA policies as a policy set to an HCP Terraform organization. The module supports multiple policy source options:

1. **Local policies**: Upload policies from a local directory
2. **Public Git repository**: Clone and upload policies from a public Git repository

## Usage

### Local Policy Files

#### Sentinel Example

```hcl
module "sentinel_policy_set" {
  source = "path/to/terraform-policy-sets"

  name         = "my-sentinel-policies"
  description  = "Sentinel policies for cost control"
  organization = "my-org"
  policy_kind  = "sentinel"
  
  policy_source      = "local"
  local_policies_path = "./policies/sentinel"
  
  # Apply to specific workspaces
  workspace_ids = ["ws-abc123", "ws-def456"]
}
```

Example Sentinel policy file (`./policies/sentinel/restrict-instance-type.sentinel`):
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

#### OPA Example

```hcl
module "opa_policy_set" {
  source = "path/to/terraform-policy-sets"

  name         = "my-opa-policies"
  description  = "OPA policies for security compliance"
  organization = "my-org"
  policy_kind  = "opa"
  
  policy_source      = "local"
  local_policies_path = "./policies/opa"
  
  # Apply to specific workspaces
  workspace_ids = ["ws-abc123", "ws-def456"]
}
```

Example OPA policy file (`./policies/opa/restrict_instance_type.rego`):
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

### Public Git Repository

```hcl
module "policy_set" {
  source = "path/to/terraform-policy-sets"

  name         = "opa-security-policies"
  description  = "OPA security policies from public repo"
  organization = "my-org"
  policy_kind  = "opa"
  
  policy_source    = "git"
  git_url          = "https://github.com/example/terraform-policies.git"
  git_branch       = "main"
  git_policies_path = "policies/opa"
  
  # Apply globally to all workspaces
  global = true
}
```

## Requirements

- Terraform >= 1.0.0
- hashicorp/tfe provider >= 0.40.0
- hashicorp/null provider >= 3.0.0
- Git command-line tool (for git source option)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name of the policy set | `string` | n/a | yes |
| description | Description of the policy set's purpose | `string` | `null` | no |
| organization | Name of the HCP Terraform organization | `string` | n/a | yes |
| policy_kind | The policy-as-code framework to use (sentinel or opa) | `string` | `"sentinel"` | no |
| agent_enabled | Whether the policy set is run as a policy evaluation within the agent | `bool` | `null` | no |
| policy_tool_version | The policy tool version to run the evaluation against | `string` | `null` | no |
| overridable | Whether users can override this policy when it fails (only valid for OPA) | `bool` | `false` | no |
| global | Whether policies apply to all workspaces | `bool` | `false` | no |
| workspace_ids | List of workspace IDs to attach the policy set to | `list(string)` | `[]` | no |
| policy_source | Source of policies: 'local' or 'git' | `string` | n/a | yes |
| local_policies_path | Path to local policy files | `string` | `null` | no |
| git_url | URL of public Git repository | `string` | `null` | no |
| git_branch | Branch of Git repository | `string` | `"main"` | no |
| git_policies_path | Path within Git repository | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_set_id | ID of the created policy set |
| policy_set_name | Name of the created policy set |
| policy_source_type | Type of policy source used |
| policy_kind | Policy framework used (sentinel or opa) |

## Notes

- When using the `git` source option, the module will clone the repository to a temporary directory within the module.
- For the `local` source option, the specified directory must exist and contain valid policy files.
- The `global` and `workspace_ids` options are mutually exclusive.
- When using `policy_kind = "opa"`, the `agent_enabled` parameter defaults to `true`.

<!-- BEGIN_TF_DOCS -->
# Terraform Policy Set Module

This Terraform module allows you to upload pre-existing Sentinel or OPA policies as a policy set to an HCP Terraform organization. The module supports multiple policy source options:

1. **Local policies**: Upload policies from a local directory
2. **Public Git repository**: Clone and upload policies from a public Git repository

## Features

- Support for both Sentinel and OPA policy frameworks
- Multiple policy source options (local directory or Git repository)
- Flexible workspace targeting (global or specific workspaces)
- Configurable policy evaluation settings

## Usage

See the [examples](./examples) directory for complete usage examples.

### Local Policy Files

For detailed examples of local policy files, see:
- [Sentinel Local Example](./examples/sentinel-local)
- [OPA Local Example](./examples/opa-local)

### Public Git Repository

```hcl
module "policy_set" {
  source = "path/to/terraform-policy-sets"

  name         = "opa-security-policies"
  description  = "OPA security policies from public repo"
  organization = "my-org"
  policy_kind  = "opa"
  policy_source    = "git"
  git_url          = "https://github.com/example/terraform-policies.git"
  git_branch       = "main"
  git_policies_path = "policies/opa"
  # Apply globally to all workspaces
  global = true
}
```

## Notes

- When using the `git` source option, the module will clone the repository to a temporary directory within the module.
- For the `local` source option, the specified directory must exist and contain valid policy files.
- The `global` and `workspace_ids` options are mutually exclusive.
- When using `policy_kind = "opa"`, the `agent_enabled` parameter defaults to `true`.
- Git command-line tool is required when using the git source option.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.0.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.0.0 |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.git_clone](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tfe_policy_set.global_policy_set](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/policy_set) | resource |
| [tfe_policy_set.workspace_policy_set](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/policy_set) | resource |
| [tfe_slug.git_policy_set](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/slug) | data source |
| [tfe_slug.policy_set](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/slug) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the policy set | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the HCP Terraform organization | `string` | n/a | yes |
| <a name="input_policy_source"></a> [policy\_source](#input\_policy\_source) | Source of the policies: 'local' for local files or 'git' for public git repository | `string` | n/a | yes |
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Whether or not the policy set is run as a policy evaluation within the agent | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the policy set's purpose | `string` | `null` | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | Branch of the Git repository to use (when policy\_source = 'git') | `string` | `"main"` | no |
| <a name="input_git_policies_path"></a> [git\_policies\_path](#input\_git\_policies\_path) | Path within the Git repository where policies are located (when policy\_source = 'git') | `string` | `""` | no |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | URL of the public Git repository containing policies (required when policy\_source = 'git') | `string` | `null` | no |
| <a name="input_global"></a> [global](#input\_global) | Whether policies in this set will apply to all workspaces | `bool` | `true` | no |
| <a name="input_local_policies_path"></a> [local\_policies\_path](#input\_local\_policies\_path) | Path to the directory containing local policy files (required when policy\_source = 'local') | `string` | `null` | no |
| <a name="input_overridable"></a> [overridable](#input\_overridable) | Whether or not users can override this policy when it fails during a run (only valid for OPA policies) | `bool` | `false` | no |
| <a name="input_policy_kind"></a> [policy\_kind](#input\_policy\_kind) | The policy-as-code framework to use (sentinel or opa) | `string` | `"sentinel"` | no |
| <a name="input_policy_tool_version"></a> [policy\_tool\_version](#input\_policy\_tool\_version) | The policy tool version to run the evaluation against | `string` | `"latest"` | no |
| <a name="input_workspace_ids"></a> [workspace\_ids](#input\_workspace\_ids) | List of workspace IDs to which the policy set should be attached (cannot be used with global = true) | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_policy_kind"></a> [policy\_kind](#output\_policy\_kind) | Policy framework used (sentinel or opa) |
| <a name="output_policy_set_id"></a> [policy\_set\_id](#output\_policy\_set\_id) | ID of the created policy set |
| <a name="output_policy_set_name"></a> [policy\_set\_name](#output\_policy\_set\_name) | Name of the created policy set |
| <a name="output_policy_source_type"></a> [policy\_source\_type](#output\_policy\_source\_type) | Type of policy source used |

## Examples

```hcl
module "sentinel_policy_set" {
  source = "../../"

  name         = "my-sentinel-policies"
  description  = "Sentinel policies for cost control"
  organization = var.organization
  policy_kind  = "sentinel"
  
  policy_source      = "local"
  local_policies_path = "${path.module}/policies"
  
  # Apply to specific workspaces
  global = true
}

variable "organization" {
  description = "HCP Terraform organization name"
  type        = string
}
```

```hcl
module "opa_policy_set" {
  source = "../../"

  name         = "my-opa-policies"
  description  = "OPA policies for security compliance"
  organization = var.organization
  policy_kind  = "opa"
  
  policy_source      = "local"
  local_policies_path = "${path.module}/policies"
  
  # Apply to specific workspaces
  global       = false
  workspace_ids = ["ws-v93RUQTMfJxoX18s"]
}


variable "organization" {
  description = "HCP Terraform organization name"
  type        = string
}
```

<!-- END_TF_DOCS -->