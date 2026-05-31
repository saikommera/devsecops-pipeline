package terraform.aws.tags_test

import data.terraform.aws.tags as tags_policy

# Test: resource missing tags should be denied
test_deny_missing_tags if {
    msgs := tags_policy.deny with input as {
        "resource_changes": [{
            "address": "aws_instance.web",
            "type": "aws_instance",
            "change": {
                "actions": ["create"],
                "after": {"tags": {}}
            }
        }]
    }
    count(msgs) > 0
}

# Test: resource with all required tags should pass
test_allow_complete_tags if {
    msgs := tags_policy.deny with input as {
        "resource_changes": [{
            "address": "aws_instance.web",
            "type": "aws_instance",
            "change": {
                "actions": ["create"],
                "after": {
                    "tags": {
                        "Environment": "prod",
                        "ManagedBy": "terraform",
                        "CostCenter": "platform-engineering",
                        "Owner": "sre-team"
                    }
                }
            }
        }]
    }
    count(msgs) == 0
}
