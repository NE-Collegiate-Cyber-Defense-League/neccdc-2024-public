# Black Team Shared

## Inputs

| Variable | Description |
| - | - |
| root_groups | Groups to add the black team user to |
| black_team_password | Password to set for the black team user |
| black_team_pub_path | Path to public key (based on the task I think) |

## Usage

```
- name: Run black team tasks
  ansible.builtin.include_tasks:
    file: "../../shared/black_team/main.yaml"
  vars:
    root_groups: admin,sudo,docker
    black_team_password: password123
    black_team_pub_path: '../../../documentation/black_team/black-team.pub'
```
