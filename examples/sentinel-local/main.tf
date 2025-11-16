module "sentinel_policy_set" {
  source = "../../"

  name         = "my-sentinel-policies"
  description  = "Sentinel policies for cost control"
  organization = "my-org"
  policy_kind  = "sentinel"

  policy_source       = "local"
  local_policies_path = "${path.module}/policies"

  # Apply to specific workspaces
  global = true
}