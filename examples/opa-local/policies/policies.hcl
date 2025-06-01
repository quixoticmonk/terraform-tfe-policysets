policy "no_friday_deploys" {
  query="data.terraform.policies.no_friday_deploys.deny"
  description="Prevent deployments on Fridays"
  enforcement_level = "mandatory"
}