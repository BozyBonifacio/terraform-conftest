terraform {
  required_version = ">= 1.6.0"
}

# terraform_data keeps this demo credential-free while still producing a real
# Terraform plan whose proposed values can be evaluated by OPA.
resource "terraform_data" "application" {
  input = {
    name        = "shift-left-demo"
    owner       = "platform-team"
    environment = "sandbox"
  }
}

