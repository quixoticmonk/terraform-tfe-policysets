# restrict_instance_type.rego
package terraform.policies.restrict_instance_type

import input.tfplan as tfplan

# Deny rule for non-compliant instances
deny[msg] {
    resource := tfplan.resource_changes[_]
    resource.type == "aws_instance"
    not instance_type_allowed(resource.change.after.instance_type)
    
    msg := sprintf(
        "❌ POLICY VIOLATION: Instance type %s is not allowed. Use t2.micro or t3.micro instead.",
        [resource.change.after.instance_type]
    )
}

# Main rule that will be evaluated and shown in the output
main = {
    "valid": valid,
    "message": message
}

# Determine if the plan is valid
valid {
    count(deny) == 0
}

# Generate appropriate message
message = msg {
    count(deny) > 0
    msg := deny[_]
} else = msg {
    msg := sprintf(
        "✅ POLICY PASSED: All AWS instances use allowed instance types (t2.micro or t3.micro).",
        []
    )
}

# Helper rule to check if instance type is allowed
instance_type_allowed(type) {
    allowed_types := ["t2.micro", "t3.micro"]
    type == allowed_types[_]
}
