provider "tfe" {
  # Configure with your HCP Terraform token
  # token = var.tfe_token
}

module "policy_set" {
  source = "../../"

  name         = "cis-policies"
  description  = "Sentinel policies supporting CIS framework"
  organization = var.organization
  policy_kind  = "sentinel"
  
  policy_source     = "git"
  git_url           = "https://github.com/quixoticmonk/policy-library-CIS-Policy-Set-for-AWS-Terraform.git"
  git_branch        = "main"
  git_policies_path = "policies"
  
  # Apply globally to all workspaces
  global = true
}

variable "organization" {
  description = "HCP Terraform organization name"
  type        = string
}

output "policy_set_id" {
  value = module.policy_set.policy_set_id
}
