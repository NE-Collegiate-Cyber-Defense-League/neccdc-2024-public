#!/bin/bash
HEIGHT=$(tput lines)
WIDTH=$(tput cols)
MENU_HEIGHT=$(( $HEIGHT - 8 ))

# Define the menu options and corresponding commands
OPTIONS=("S1 Windows" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/windows/playbook.yaml"
         "S1 Identity" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_server"
         "S1 GitLab" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/gitlab/playbook.yml"
         "S1 Vault" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/vault/playbook.yml"
         "S1 Wazuh" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/wazuh/playbook.yml"
         "S1 PLC" "ansible-playbook /root/neccdc-2024/neccdc_ics_2024/openplc_scripts/playbook.yml -e 'state=present'"
         "S2 Identity" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_trust,ipa_populate"
         "S2 Kubernetes" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/kubernetes/playbook.yaml"
         "S3 Identity" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_clients"
         "S3 Wazuh" "ansible-playbook /root/neccdc-2024/ansible/regionals/post/wazuh/agent.yml"
         "Exit" "exit"
        )

# Prompt the user to select an option
CHOICE=$(whiptail --title "Menu" \
        --menu "Choose an option:" \
        $HEIGHT $WIDTH $MENU_HEIGHT \
        "${OPTIONS[@]}" \
        3>&1 1>&2 2>&3)

# Execute the selected command based on the choice
case $CHOICE in
    "S1 Windows")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/windows/playbook.yaml
        ;;
    "S1 Identity")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_server
        ;;
    "S1 GitLab")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/gitlab/playbook.yml
        ;;
    "S1 Vault")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/vault/playbook.yml
        ;;
    "S1 Wazuh")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/wazuh/playbook.yml
        ;;
    "S1 PLC")
        ansible-playbook /root/neccdc-2024/neccdc_ics_2024/openplc_scripts/playbook.yml -e "state=present"
        ;;
    "S2 Identity")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_trust,ipa_populate
        ;;
    "S2 Kubernetes")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/kubernetes/playbook.yaml
        ;;
    "S3 Identity")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/identity/playbook.yml --tags ipa_clients
        ;;
    "S3 Wazuh")
        ansible-playbook /root/neccdc-2024/ansible/regionals/post/wazuh/agent.yml
        ;;
    "Exit")
        echo "Exiting..."
        ;;
    *)
        echo "Invalid option"
        ;;
esac