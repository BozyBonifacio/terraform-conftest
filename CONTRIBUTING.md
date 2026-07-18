# Contributing

1. Create a branch from `main`.
2. Run `make policy test`.
3. Push the branch and open a pull request.

To demonstrate enforcement, set `environment = "sandbox"` in `main.tf`. The pull-request workflow should reject the plan. Restore an allowed environment to make it pass.
