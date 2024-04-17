GitLab Role
=========

This role handles the installation and configuration of GitLab. It is based of the role from [geerlingguy](https://github.com/geerlingguy/ansible-role-gitlab).

Entry Points
------------

### Main Entry Point


### Post Entry Point


Role Variables
--------------

- **gitlab_domain**: Domain name for GitLab. Default is gitlab.
- **gitlab_ssl**: Enable SSL. Boolean value. Default is false.
- **gitlab_create_self_signed_cert**: Create a self-signed SSL certificate. Boolean value. Default is false.
- **gitlab_external_domain**: Fully qualified domain name for GitLab. Default is `gitlab.{{ **gitlab_domain** }}`.
- **gitlab_external_url**: External URL for GitLab access. Composed based on SSL settings.
- **gitlab_registry_domain**: Domain for GitLab container registry. Default is `registry.{{ **gitlab_domain** }}`.
- **gitlab_registry_url**: URL for GitLab container registry. Composed based on SSL settings.
- **gitlab_edition**: GitLab edition (gitlab-ce for Community Edition or gitlab-ee for Enterprise Edition). Default is gitlab-ce.
- **gitlab_version**: Specific GitLab version to install. Default is 16.0.0-ce.0.
- **gitlab_timezone**: Server timezone. Default is America/New_York.
- **gitlab_root_password**: Root password for GitLab. Default is a sample password.
- **gitlab_runners_token**: Token for GitLab runners. Default is a sample token.
- **gitlab_sshd**: SSHD settings (enabled, listen_port, generate_host_keys).
- **gitlab_letsencrypt**: Let's Encrypt settings (enabled).
- **gitlab_restart_handler_failed_when**: Condition for restart handler failure.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
