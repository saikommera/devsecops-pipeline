package terraform.aws.tags_test

import data.terraform.aws.tags

# Test: resource missing all required tags should be denied
test_deny_missing_tags {
  deny_msgs := tags.deny with input as {
    "resource_changes": [{
      "address": "aws_instance.web",
      "type": "aws_instance",
      "change": {
        "actions": ["create"],
        "after": {
          "tags": {}
        }
      }
    }]
  }
  count(deny_msgs) > 0
}

# Test: resource with all required tags should not be denied
test_allow_all_tags {
  deny_msgs := tags.deny with input as {
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
  count(deny_msgs) == 0
}

# Test: invalid Environment tag value should be denied
test_deny_invalid_environment {
  deny_msgs := tags.deny with input as {
    "resource_changes": [{
      "address": "aws_instance.web",
      "type": "aws_instance",
      "change": {
        "actions": ["create"],
        "after": {
          "tags": {
            "Environment": "invalid-env",
            "ManagedBy": "terraform",
            "CostCenter": "eng",
            "Owner": "team"
          }
        }
      }
    }]
  }
  count(deny_msgs) > 0
}
