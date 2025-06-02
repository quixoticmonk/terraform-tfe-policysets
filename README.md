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

For an example of using policies from a Git repository, see:
- [Git Policies Example](./examples/git-policies)

```hcl
module "policy_set" {
  source = "path/to/terraform-policy-sets"

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

## Notes

- When using the `git` source option, the module will clone the repository to a temporary directory within the module.
- For the `local` source option, the specified directory must exist and contain valid policy files.
- The `global` and `workspace_ids` options are mutually exclusive.
- When using `policy_kind = "opa"`:
  - The `agent_enabled` parameter is always set to `true`, regardless of the input value
  - The `overridable` parameter is only valid for OPA policies and ignored for Sentinel policies
- Git command-line tool is required when using the git source option.

## Examples

### Sentinel Local Policies

```hcl
module "sentinel_policy_set" {
  source = "../../"

  name         = "my-sentinel-policies"
  description  = "Sentinel policies for cost control"
  organization = "my-org"
  policy_kind  = "sentinel"
  policy_source      = "local"
  local_policies_path = "${path.module}/policies"
  # Apply globally to all workspaces
  global = true
}
```

### OPA Local Policies

```hcl
module "opa_policy_set" {
  source = "../../"

  name         = "my-opa-policies"
  description  = "OPA policies for compliance"
  organization = "my-org"
  policy_kind  = "opa"
  policy_source       = "local"
  local_policies_path = "${path.module}/policies"
  # Apply to specific workspaces
  global        = false
  workspace_ids = ["ws-v93RUQTMfJxoX18s"]
}
```

### Git Repository Policies

```hcl
module "policy_set" {
  source = "../../"

  name              = "cis-policies"
  description       = "Sentinel policies supporting CIS framework"
  organization      = var.organization
  policy_kind       = "sentinel"
  policy_source     = "git"
  git_url           = "https://github.com/quixoticmonk/policy-library-CIS-Policy-Set-for-AWS-Terraform.git"
  git_branch        = "main"
  git_policies_path = "./"

  # Apply globally to all workspaces
  global = true
}

variable "organization" {
  description = "HCP Terraform organization name"
  type        = string
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | >= 0.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [terraform_data.git_clone](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
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
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Whether or not the policy set is run as a policy evaluation within the agent. Always true for OPA policies regardless of this setting. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the policy set's purpose | `string` | `null` | no |
| <a name="input_git_branch"></a> [git\_branch](#input\_git\_branch) | Branch of the Git repository to use (when policy\_source = 'git') | `string` | `"main"` | no |
| <a name="input_git_policies_path"></a> [git\_policies\_path](#input\_git\_policies\_path) | Path within the Git repository where policies are located (when policy\_source = 'git') | `string` | `""` | no |
| <a name="input_git_url"></a> [git\_url](#input\_git\_url) | URL of the public Git repository containing policies (required when policy\_source = 'git') | `string` | `null` | no |
| <a name="input_global"></a> [global](#input\_global) | Whether policies in this set will apply to all workspaces | `bool` | `true` | no |
| <a name="input_local_policies_path"></a> [local\_policies\_path](#input\_local\_policies\_path) | Path to the directory containing local policy files (required when policy\_source = 'local') | `string` | `null` | no |
| <a name="input_overridable"></a> [overridable](#input\_overridable) | Whether or not users can override this policy when it fails during a run. Only valid for OPA policies; ignored for Sentinel policies. | `bool` | `false` | no |
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
  organization = "my-org"
  policy_kind  = "sentinel"
  
  policy_source      = "local"
  local_policies_path = "${path.module}/policies"
  
  # Apply to specific workspaces
  global = true
}
```

```hcl
module "opa_policy_set" {
  source = "../../"

  name         = "my-opa-policies"
  description  = "OPA policies for compliance"
  organization = "my-org"
  policy_kind  = "opa"

  policy_source       = "local"
  local_policies_path = "${path.module}/policies"

  # Apply to specific workspaces
  global        = false
  workspace_ids = ["ws-v93RUQTMfJxoX18s"]
}
```
