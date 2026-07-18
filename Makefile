.PHONY: init plan policy test clean

init:
	terraform init -backend=false

plan: init
	terraform plan -input=false -out=tfplan
	terraform show -json tfplan > plan.json

policy: plan
	conftest test plan.json --policy policy --all-namespaces

test:
	conftest verify --policy policy

clean:
	rm -f tfplan plan.json

