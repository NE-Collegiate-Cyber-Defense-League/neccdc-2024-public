#!/bin/bash

# Switch DIR bruh
cd /root/neccdc-2024/terraform/qualifiers/environments/blue_team

# Loop through Terraform workspaces numbered 1 through 20
for workspace_num in {1..20}; do
    workspace_name="${workspace_num}"

    # Check if the workspace exists before running `terraform apply`
    if terraform workspace select "${workspace_name}" 2>/dev/null; then
        echo "Running terraform destroy for ${workspace_name}..."
        terraform destroy -target=module.ec2 -auto-approve
    else
        echo "Workspace ${workspace_name} does not exist. Skipping."
    fi
done
