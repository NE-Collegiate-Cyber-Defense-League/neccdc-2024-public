ARG SCRIPTS=/tmp/scripts

FROM mcr.microsoft.com/devcontainers/base:jammy as base
COPY scripts/ /tmp/scripts/
RUN chmod u+x /tmp/scripts/*.sh
RUN /tmp/scripts/install.sh

FROM base as fish
RUN /tmp/scripts/fish.sh

FROM fish as ansible
RUN /tmp/scripts/ansible.sh

FROM ansible as aws
RUN /tmp/scripts/aws.sh

FROM aws as hashicorp
RUN /tmp/scripts/hashicorp.sh

FROM hashicorp as powershell
RUN /tmp/scripts/powershell.sh