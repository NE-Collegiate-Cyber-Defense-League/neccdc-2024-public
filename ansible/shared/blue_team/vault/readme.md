# Blue Team Access to Vault Host

This is already configured by the installation of vault on the vault host. Specifcally, handled through the role in packer:

```yaml
- name: Install Vault Role
  ansible.builtin.include_role:
    name: vault
  vars:
    vault_config_path: /usr/local/etc/vault.hcl
    vault_data_dir: /var/db/vault
    vault_ssh_pass: waffles142
```