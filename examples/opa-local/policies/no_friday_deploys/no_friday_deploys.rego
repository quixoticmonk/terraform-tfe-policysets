# no_friday_deploys.rego
package terraform.policies.no_friday_deploys

# Deny rule for deployments on Friday
deny[msg] {
    # Get the current day of the week as a string
    day := time.weekday(time.now_ns())
    day == "Friday"
    
    msg := sprintf(
        "❌ POLICY VIOLATION: Deployments are not allowed on Fridays. Please try again on another day.",
        []
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
        "✅ POLICY PASSED: Today is not Friday, deployment is allowed.",
        []
    )
}
