# Ansible Wireguard

Ansibilized Wireguard setup.

Based on the 2023 [remote access](https://github.com/NE-Collegiate-Cyber-Defense-League/neccdc-2023/tree/main/remote-access) setup.
Uses [wg-easy](https://github.com/wg-easy/wg-easy) for easier deployment on containers and api to setup clients.

## Inputs

| Variable | Description |
| - | - |
| wireguard_public_host | FQDN or IP of the wireguard instance |
| wireguard_subnet_black_team | Network range for black team wireguard clients. ex "172.16.127.x" |
| wireguard_subnet_blue_team | Network range to put blue team wireguard clients. ex "172.16" |
| blue_team_subnet | Network of the blue team. ex "10.0" |
| blue_team_block | Subnet block that belong to each team |
| wireguard_black_team_password | Black team wireguard password |
| black_team_clients | List of black team client names |
| number_of_teams | Number of teams to create. starting index of 0 |
| output_dir | Location of the zip of the client configuration |

## Recovery

Once the server has been deployed once it can be redeployed by moving it back to a servers `/opt/wireguard` directory which will be picked up by the deployment.

Once that is completed run the playbook with the **base** tag.

```bash
ansible-playbook playbook.yaml --tags base
```