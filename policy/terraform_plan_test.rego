package terraform.plan_test

import rego.v1
import data.terraform.plan

test_valid_plan_allows_change if {
  count(plan.deny) == 0 with input as valid_plan
}

test_missing_owner_is_denied if {
  some message in plan.deny with input as missing_owner_plan
  contains(message, "input.owner")
}

test_invalid_environment_is_denied if {
  some message in plan.deny with input as invalid_environment_plan
  contains(message, "input.environment")
}

test_delete_is_denied if {
  some message in plan.deny with input as delete_plan
  contains(message, "cannot be deleted")
}

valid_plan := {
  "planned_values": {"root_module": {"resources": [{
    "address": "terraform_data.application",
    "mode": "managed",
    "type": "terraform_data",
    "values": {"input": {"owner": "platform-team", "environment": "development"}}
  }]}},
  "resource_changes": []
}

missing_owner_plan := object.union(valid_plan, {
  "planned_values": {"root_module": {"resources": [{
    "address": "terraform_data.application",
    "mode": "managed",
    "type": "terraform_data",
    "values": {"input": {"environment": "development"}}
  }]}}
})

invalid_environment_plan := object.union(valid_plan, {
  "planned_values": {"root_module": {"resources": [{
    "address": "terraform_data.application",
    "mode": "managed",
    "type": "terraform_data",
    "values": {"input": {"owner": "platform-team", "environment": "sandbox"}}
  }]}}
})

delete_plan := object.union(valid_plan, {
  "resource_changes": [{
    "address": "terraform_data.application",
    "change": {"actions": ["delete"]}
  }]
})

