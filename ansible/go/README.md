# Nodejs

Installs nodejs on designated hosts. 

## Ansible Galaxy

### Install 

```
docker run \
-v ${PWD}:/app \
-v ${PWD}/roles:/app/.ansible/roles \
-v ~/.ssh:/app/.ssh \
--rm ansible:local ansible-galaxy role install geerlingguy.nodejs
```

## Run Ansible Playbook

```
docker run \
-v ${PWD}:/app \
-v ${PWD}/roles:/app/.ansible/roles \
-v ~/.ssh:/app/.ssh \
--rm ansible:local ansible-playbook main.yaml
```