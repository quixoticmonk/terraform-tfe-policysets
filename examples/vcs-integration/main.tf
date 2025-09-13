module "policy_set" {
  source = "../../"

  name              = "cis-policies-vcs"
  description       = "CIS policies via VCS integration"
  organization      = var.organization
  policy_kind       = "sentinel"
  policy_source     = "vcs"
  vcs_identifier    = "quixoticmonk/policy-library-CIS-Policy-Set-for-AWS-Terraform"
  git_branch        = "main"
  oauth_token_id    = var.oauth_token_id
  
  # Apply globally to all workspaces
  global = true
}
