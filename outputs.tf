output "policy_set_id" {
  description = "ID of the created policy set"
  value       = var.global ? tfe_policy_set.global_policy_set[0].id : tfe_policy_set.workspace_policy_set[0].id
}

output "policy_set_name" {
  description = "Name of the created policy set"
  value       = var.global ? tfe_policy_set.global_policy_set[0].name : tfe_policy_set.workspace_policy_set[0].name
}

output "policy_source_type" {
  description = "Type of policy source used"
  value       = var.policy_source
}

output "policy_kind" {
  description = "Policy framework used (sentinel or opa)"
  value       = var.global ? tfe_policy_set.global_policy_set[0].kind : tfe_policy_set.workspace_policy_set[0].kind
}
