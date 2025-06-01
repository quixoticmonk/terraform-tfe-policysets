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