/**
 * # Terraform Policy Set Module
 *
 * This module uploads pre-existing Sentinel or OPA policies as a policy set to an HCP Terraform organization.
 * It supports two policy source options:
 * - Local policy files
 * - Public Git repository
 *
 * Note: For OPA policies, agent_enabled is always set to true and overridable is only applied for OPA policies.
 */

# Data source to create a slug from local policy files
data "tfe_slug" "policy_set" {
  count       = var.policy_source == "local" ? 1 : 0
  source_path = var.local_policies_path
}

# Create a local directory for Git clone if using git source
resource "terraform_data" "git_clone" {
  count = var.policy_source == "git" ? 1 : 0

  triggers_replace = {
    git_url            = var.git_url
    git_branch         = var.git_branch
    ingress_submodules = var.ingress_submodules
    timestamp          = timestamp() # Force periodic refresh to catch upstream changes
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ${path.module}/tmp
      rm -rf ${path.module}/tmp/git_policies
      git clone --depth 1 --branch ${var.git_branch} ${var.ingress_submodules ? "--recurse-submodules" : ""} ${var.git_url} ${path.module}/tmp/git_policies
    EOT
  }
}

# Create slug from git-cloned policies
data "tfe_slug" "git_policy_set" {
  count       = var.policy_source == "git" ? 1 : 0
  source_path = "${path.module}/tmp/git_policies/${var.git_policies_path}"
  
  depends_on = [terraform_data.git_clone]
}

# Create the policy set resource for global policies
resource "tfe_policy_set" "global_policy_set" {
  count               = var.global ? 1 : 0
  name                = var.name
  description         = var.description
  organization        = var.organization
  kind                = var.policy_kind
  agent_enabled       = var.policy_kind == "opa" ? true : var.agent_enabled
  policy_tool_version = var.policy_tool_version
  overridable         = var.policy_kind == "opa" ? var.overridable : null
  
  # Set global to true
  global = true
  
  # Set slug based on policy source (only for local and git)
  slug = var.policy_source == "vcs" ? null : (var.policy_source == "local" ? data.tfe_slug.policy_set[0] : data.tfe_slug.git_policy_set[0])
  
  # VCS repo configuration for VCS source
  dynamic "vcs_repo" {
    for_each = var.policy_source == "vcs" ? [1] : []
    content {
      identifier                 = var.vcs_identifier
      branch                     = var.git_branch
      ingress_submodules        = var.ingress_submodules
      oauth_token_id            = var.oauth_token_id
      github_app_installation_id = var.github_app_installation_id
    }
  }
}

# Create the policy set resource for workspace-specific policies
resource "tfe_policy_set" "workspace_policy_set" {
  count               = var.global ? 0 : 1
  name                = var.name
  description         = var.description
  organization        = var.organization
  kind                = var.policy_kind
  agent_enabled       = var.policy_kind == "opa" ? true : var.agent_enabled
  policy_tool_version = var.policy_tool_version
  overridable         = var.policy_kind == "opa" ? var.overridable : null
    
  # Include workspace_ids
  workspace_ids = var.workspace_ids
  
  # Set slug based on policy source (only for local and git)
  slug = var.policy_source == "vcs" ? null : (var.policy_source == "local" ? data.tfe_slug.policy_set[0] : data.tfe_slug.git_policy_set[0])
  
  # VCS repo configuration for VCS source
  dynamic "vcs_repo" {
    for_each = var.policy_source == "vcs" ? [1] : []
    content {
      identifier                 = var.vcs_identifier
      branch                     = var.git_branch
      ingress_submodules        = var.ingress_submodules
      oauth_token_id            = var.oauth_token_id
      github_app_installation_id = var.github_app_installation_id
    }
  }
}
