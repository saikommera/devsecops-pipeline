package terraform.aws.tags

import rego.v1

required_tags := {"Environment", "ManagedBy", "CostCenter", "Owner"}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.actions[_] == "create"
    missing := required_tags - {tag | resource.change.after.tags[tag]}
    count(missing) > 0
    msg := sprintf(
        "Resource '%v' (%v) missing required tags: %v",
        [resource.address, resource.type, missing]
    )
}

deny contains msg if {
    resource := input.resource_changes[_]
    resource.change.after.tags["Environment"]
    valid := {"dev", "staging", "prod"}
    not valid[resource.change.after.tags["Environment"]]
    msg := sprintf(
        "Resource '%v' has invalid Environment tag: '%v'",
        [resource.address, resource.change.after.tags["Environment"]]
    )
}
