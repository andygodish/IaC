# Ping

Simple playbook for testing an ansible configuration against infrastructure. 

## Usage

### Dev

When building, use the `--target dev` flag. 

```
cd python/ansible/ping
```
```
docker build -t ping:dev --target dev .
```

```
docker run -it \
-v ${PWD}:/home/appuser/app \
-v ${PWD}/roles:/home/appuser/.ansible/roles \
-v /tmp/.test-ssh:/home/appuser/.ssh \
--rm ping:dev /bin/bash
```

### Prod

Build sans --target dev.

From the root of this repo:
```
docker build -t ping:prod -f ./python/ansible/ping/dockerfile .docker build -t ping:prod .
```

Now you only need to supply the ssh key for your hosts since the build target (dockerfile) copies the content of the ansible project in the container image:

```
docker run -it -v /tmp/.test-ssh:/home/appuser/.ssh \              
--rm ping:prod
```

**Problem****

The hosts.ini file is now statically built. Don't do this without overriding it.