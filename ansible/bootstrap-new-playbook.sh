#!/bin/bash

if [ -z "$ANSIBLE_PLAYBOOK_NAME" ]; then
  echo "ANSIBLE_PLAYBOOK_NAME environment variable is not set. Exiting..."
  exit 1
else
  echo "Creating Ansible playbook named: $ANSIBLE_PLAYBOOK_NAME"
  mkdir -p $ANSIBLE_PLAYBOOK_NAME/inventory
  mkdir $ANSIBLE_PLAYBOOK_NAME/roles
  mkdir $ANSIBLE_PLAYBOOK_NAME/collections

  cp /config/ansible.cfg /app/$ANSIBLE_PLAYBOOK_NAME
  cp /config/hosts.ini.example /app/$ANSIBLE_PLAYBOOK_NAME/inventory/hosts.ini
fi
