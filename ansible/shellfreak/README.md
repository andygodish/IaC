# Shellfreak

- [Ansible Galaxy](https://galaxy.ansible.com/ui/repo/published/drew1kun/shellfreak/)

## Usage

### Install Ansible Galaxy Collection

```
docker run \
-v ${PWD}:/app \
-v ${PWD}/roles:/app/.ansible/roles \
-v ~/.ssh:/app/.ssh \
--rm ansible:local ansible-galaxy collection install drew1kun.shellfreak
```

### OhMyZsh

After running this module, you will be prompted to configure the Powerlevel10k theme. You can run the wizard anytime by running `p10k configure`.

- preferences: n, n, n, y, 1 (Lean), 1 (Unicode), 1 (256 colors), n, 1, 1, 1, n, 1, y
