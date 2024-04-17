# Terraform AWS Infrastructure Module for Blue Team
This Terraform module is designed to manage a comprehensive AWS infrastructure, primarily focused on networking and EC2 instance management for a blue team environment.

## Module Overview
- settings.tf: Specifies the required Terraform version, backend configuration for state management using an S3 bucket, and the AWS provider version.
- variables.tf: Defines input variables for controlling the creation of EC2 instances. These variables are passed to the child EC2 module.
- data.tf: Contains data sources for AWS resources like VPCs and route tables, specifying filters for resource selection based on tags.
- main.tf: Includes local definitions, and references to the network and ec2 child modules, passing necessary variables and data.
- readme.md: Provides basic instructions for creating and switching between different team workspaces.
  
## Usage

### Initializing the Workspace
To initialize a new workspace for a team, use the following commands:

```
terraform workspace new [team_number] 
```
```
terraform workspace select [team_number]
```

### Applying the Configuration

To apply the Terraform configuration, simply run:
```
terraform apply
```

Override default instance creation variables as needed by passing **-var** arguments.

### Example: Creating Selective Instances

To create all instances except `win-01` and `win-02`, run:
```
terraform apply -var="create_win_01=false" -var="create_win_02=false"
```
This command will apply the Terraform plan while preventing the creation of `win-01` and `win-02`.