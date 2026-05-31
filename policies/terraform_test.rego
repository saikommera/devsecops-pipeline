package terraform.aws.tags_test

import rego.v1
import data.terraform.aws.tags

test_deny_missing_tags if {
    msgs := tags.deny with input as {
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

test_allow_complete_tags if {
    msgs := tags.deny with input as {
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
