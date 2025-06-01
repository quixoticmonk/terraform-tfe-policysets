# restrict_instance_type.rego
package terraform.policies

import input.tfplan as tfplan

# Deny rule for non-compliant instances
deny[msg] {
    resource := tfplan.resource_changes[_]
    resource.type == "aws_instance"
    resource.change.after.instance_type not in ["t2.micro", "t3.micro"]
    
    msg := sprintf(
        "Instance type %s is not allowed. Use t2.micro or t3.micro instead.",
        [resource.change.after.instance_type]
    )
}
