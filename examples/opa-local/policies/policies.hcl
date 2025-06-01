policy "restrict_instance_type" {
  query="data.terraform.policies.restrict_instance_type.deny"
  description="Restrict instance type"
  enforcement_level = "mandatory"
}