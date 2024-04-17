#!/bin/bash

# Switch DIR bruh
cd /root/neccdc-2024/terraform/regionals/environments/blue_team

# Loop through Terraform workspaces numbered 1 through 20
for workspace_num in {1..10}; do
    workspace_name="${workspace_num}"

    # Check if the workspace exists before running `terraform apply`
    if terraform workspace select "${workspace_name}" 2>/dev/null; then
        echo "Running terraform apply for ${workspace_name}..."
        terraform apply -auto-approve
    else
        echo "Workspace ${workspace_name} does not exist. Skipping."
    fi
done
