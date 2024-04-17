Post Wazuh
=========

The post configuration for Wazuh handles setting up the Wazuh server, populating the Wazuh server with agents, etc.

Ansible Variables
--------------


Ansible Roles
------------
The following roles are used for the post configuration of Wazuh:

- []

Entry Points
------------

### Main Entry Point

The [playbook.yaml](/ansible/regionals/post/Wazuh/playbooks/domain_create.yaml) file is the main entry point for the post configuration of the Wazuh regionals. This file imports multiple playbooks to handle the different aspects of the post configuration. The playbooks are located in the [playbooks](/ansible/regionals/post/Wazuh/playbooks/) directory. 

#### Domain Creation

The playbook [domain_create.yaml](/ansible/regionals/post/Wazuh/playbooks/domain_create.yaml) handles configuring **win_dc** to establish a new Active Directory domain. It performs the following tasks:

- Set NTP server
- Set Timezone to EST
- Updates Hostname
- Install Active Directory Domain Services
- Creates `black-team` user

```mermaid
---
title: Ansible Playbook Grapher
---
%%{ init: { "flowchart": { "curve": "bumpX" } } }%%
flowchart LR
	%% Start of the playbook 'playbook.yml'
	playbook_959acae5("playbook.yml")
		%% Start of the play 'Play: Wazuh Post Install (11)'
		play_b9eefe73["Play: Wazuh Post Install (11)"]
		style play_b9eefe73 fill:#6e5874,color:#ffffff
		playbook_959acae5 --> |"1"| play_b9eefe73
		linkStyle 0 stroke:#6e5874,color:#6e5874
			%% Start of the role '../../roles/hostsetup'
			play_b9eefe73 --> |"1"| role_139737f6
			linkStyle 1 stroke:#6e5874,color:#6e5874
			role_139737f6("[role] ../../roles/hostsetup")
			style role_139737f6 fill:#6e5874,color:#ffffff,stroke:#6e5874
			%% End of the role '../../roles/hostsetup'
			task_b503d863["[task]  BlueTeam - Include centralized credentials"]
			style task_b503d863 stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"2"| task_b503d863
			linkStyle 2 stroke:#6e5874,color:#6e5874
			task_1a1d7bbc["[task]  BlueTeam - Set user fact from credentials"]
			style task_1a1d7bbc stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"3"| task_1a1d7bbc
			linkStyle 3 stroke:#6e5874,color:#6e5874
			task_f1c8aa50["[task]  BlueTeam - Configure the defined user"]
			style task_f1c8aa50 stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"4"| task_f1c8aa50
			linkStyle 4 stroke:#6e5874,color:#6e5874
			task_b0ea1e4c["[task]  Copy the TLS certificate"]
			style task_b0ea1e4c stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"5"| task_b0ea1e4c
			linkStyle 5 stroke:#6e5874,color:#6e5874
			task_6fee1d43["[task]  Copy the TLS key"]
			style task_6fee1d43 stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"6"| task_6fee1d43
			linkStyle 6 stroke:#6e5874,color:#6e5874
			task_6e7b63cb["[task]  Template the Wazuh configuration"]
			style task_6e7b63cb stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"7"| task_6e7b63cb
			linkStyle 7 stroke:#6e5874,color:#6e5874
			task_33ad2684["[task]  Restart Wazuh dashboard service"]
			style task_33ad2684 stroke:#6e5874,fill:#ffffff
			play_b9eefe73 --> |"8"| task_33ad2684
			linkStyle 8 stroke:#6e5874,color:#6e5874
		%% End of the play 'Play: Wazuh Post Install (11)'
	%% End of the playbook 'playbook.yml'


```