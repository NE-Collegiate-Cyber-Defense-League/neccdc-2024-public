# NECCDL 2024

<!-- Doors pull and push -->

## About the Project

- [Andrew Iadevaia](https://github.com/andrewiadevaia)
- [Andrew Aiken](https://github.com/andrew-aiken)
- [Evan Soroken](https://github.com/ESoro25)
- [Justin Marwad](https://github.com/justinmarwad)
- [Manoj Sarma](https://github.com/07Manoj)
- [Jason Gendron](https://github.com/jasongendron)

## Ansible
This directory contains a majority of the code base for shaping the individual hosts and services within the environment. The [Regionals](/ansible/regionals) directory contain multiple resources defined below. The [Shared](/ansible/shared) directory contains resources not specific to regionals.

#### Inventory
Contains the inventory files necessary for ansible to be able to target multiple teams with a inventory group. Utilizing ansible's ability for [adding ranges of hosts](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#adding-ranges-of-hosts) and [inventory load order](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html#managing-inventory-load-order) we can abstract the creation of the inventory hostvars from individual host -> host groups -> all hosts. To supplement this, an `ansible.cfg` file is included to specify the inventory file to use.

#### Pre
This directory contains all the packer build configurations for the competition. Each host is either broken down into a seperate directory or is grouped into a single directory with multiple hosts based on category. The directories contain the necessary packer build configurations, typically within a folder named `packer`, and any necessary provisioning scripts located at the same level as the `packer` folder.

#### Post
This directory contains all configuration and setup tasks for anything that could not be completed in the [Packer](#Pre) stage. The majority of the codebase is Ansible with some special scripts for edge cases ansible could not handle. Similar to the [Pre](#Pre) directory, the [Post](#Post) directory is broken down into individual host directories or grouped into a single directory with multiple hosts based on category.

### Shared
- [black-team](/ansible/shared/black_team) - Tasks to provision a black-team user.
- [blue-team](/ansible/shared/blue_team) - Tasks to provision blue-team users for their respective host.
- [wireguard](/ansible/shared/wireguard) - Tasks to setup wireguard EC2 instance, wg-easy docker containers, and black, blue, and red team certs.

## Docuemntation
This directory contains all the documentation for the competition. The documentation is broken down into the following categories:
- [Archives](/documentation/archives) - Contains old documentation that is no longer relevant.
- [Black Team](/documentation/black_team) - Contains the black team ssh keys.
- [Blue Team Access](/documentation/blue_team_access) - Contains the `dynamically generated` blue team access folders (wireguard certs, classroom creds, scorestack creds, and vault tokens).
- [Certs](/documentation/certs) - Contains the `dynamically generated` blue team letsencrypt certs for the **regionals**.

## Scorestack
This directory contains the necessary resources to provision the scorestack engine for the competition. The scorestack engine is provisioned and controlled souley through ansible.

## Scripts
This directory contains testing and helper scripts for the competition. The scripts are ad-hoc in nature and are not meant to be used in a production environment. Mainly for the purpose of testing and debugging.

## Terraform
This directory contains the necessary resources to provision the infrastructure for the competition on AWS. Most of the repition in the codebase is abstracted into modules to make the codebase more maintainable and easier to use.

#### Regionals
- [environments](/terraform/regionals/environments) - Contains the terraform state for the qualifiers.
    - [black_team](/terraform/regionals/environments/black_team) - Contains the terraform state for the black team.
    - [blue_team](/terraform/regionals/environments/blue_team) - Contains the terraform state for the blue team.
    - [certs](/terraform/regionals/environments/certs) - Contains the terraform state for the letsencrypt certs.
    - [management_access](/terraform/regionals/environments/management_access) - Contains the terraform state for AWS account provisioning.
- [modules](/terraform/regionals/modules) - Contains the necessary terraform code to provision the infrastructure for the qualifiers.
    - [account](/terraform/regionals/modules/account) - Contains the necessary terraform code to provision AWS accounts.
    - [certificates](/terraform/regionals/modules/certificates) - Contains the necessary terraform code to provision letsencrypt certs.
    - [cloudtrail](/terraform/regionals/modules/cloudtrail) - Contains the necessary terraform code to provision cloudtrail.
    - [ec2](/terraform/regionals/modules/ec2) - Contains the necessary terraform code to provision the ec2 instances for the regionals.
    - [iam](/terraform/regionals/modules/iam) - Contains the necessary terraform code to provision IAM roles and policies.
    - [route53](/terraform/regionals/modules/route53) - Contains the necessary terraform code to provision route53 records.
    - [vpc](/terraform/regionals/modules/vpc) - Contains the necessary terraform code to provision VPCs.

##
<details>
    <summary>Click Me</summary>

```
  .---.       ,-----.    ,---.  ,---.   .-''-.
  | ,_|     .'  .-,  '.  |   /  |   | .'_ _   \
,-./  )    / ,-.|  \ _ \ |  |   |  .'/ ( ` )   '
\  '_ '`) ;  \  '_ /  | :|  | _ |  |. (_ o _)  |
 > (_)  ) |  _`,/ \ _/  ||  _( )_  ||  (_,_)___|
(  .  .-' : (  '\_/ \   ;\ (_ o._) /'  \   .---.
 `-'`-'|___\ `"/  \  ) /  \ (_,_) /  \  `-'    /
  |        \'. \_/``".'    \     /    \       /
  `--------`  '-----'       `---`      `'-..-'

 _______     .---.        ____        _______   .--.   .--.
\  ____  \   | ,_|      .'  __ `.    /   __  \  |  | _/  /
| |    \ | ,-./  )     /   '  \  \  | ,_/  \__) | (`' ) /
| |____/ / \  '_ '`)   |___|  /  |,-./  )       |(_ ()_)
|   _ _ '.  > (_)  )      _.-`   |\  '_ '`)     | (_,_)   __
|  ( ' )  \(  .  .-'   .'   _    | > (_)  )  __ |  |\ \  |  |
| (_{;}_) | `-'`-'|___ |  _( )_  |(  .  .-'_/  )|  | \ `'   /
|  (_,_)  /  |        \\ (_ o _) / `-'`-'     / |  |  \    /
/_______.'   `--------` '.(_,_).'    `._____.'  `--'   `'-'

,---------.    .-''-.     ____    ,---.    ,---.
\          \ .'_ _   \  .'  __ `. |    \  /    |
 `--.  ,---'/ ( ` )   '/   '  \  \|  ,  \/  ,  |
    |   \  . (_ o _)  ||___|  /  ||  |\_   /|  |
    :_ _:  |  (_,_)___|   _.-`   ||  _( )_/ |  |
    (_I_)  '  \   .---..'   _    || (_ o _) |  |
   (_(=)_)  \  `-'    /|  _( )_  ||  (_,_)  |  |
    (_I_)    \       / \ (_ o _) /|  |      |  |
    '---'     `'-..-'   '.(_,_).' '--'      '--'
```
</details>