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