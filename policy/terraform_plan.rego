package terraform.plan

import rego.v1

managed_resources contains resource if {
  resource := input.planned_values.root_module.resources[_]
  resource.mode == "managed"
}

deny contains msg if {
  resource := managed_resources[_]
  resource.type == "terraform_data"

  owner := object.get(resource.values.input, "owner", "")
  not non_empty(owner)

  msg := sprintf(
    "%s must set a non-empty input.owner",
    [resource.address],
  )
}

deny contains msg if {
  resource := managed_resources[_]
  resource.type == "terraform_data"

  environment := object.get(
    resource.values.input,
    "environment",
    "",
  )
  not allowed_environment(environment)

  msg := sprintf(
    "%s input.environment must be development, staging, or production",
    [resource.address],
  )
}

deny contains msg if {
  change := input.resource_changes[_]
  "delete" in change.change.actions

  msg := sprintf(
    "%s cannot be deleted without an explicit policy exception",
    [change.address],
  )
}

non_empty(value) if {
  is_string(value)
  trim_space(value) != ""
}

allowed_environment(value) if {
  value in {
    "development",
    "staging",
    "production",
  }
}