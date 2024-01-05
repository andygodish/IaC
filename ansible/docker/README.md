# Docker

Installs docker on designated hosts. 

## Usage

### Dev

When building, use the `--target dev` flag. 

```
cd python/ansible/ping
```
```
docker build -t docker:dev --target dev .
```

```
docker run -it \
-v ${PWD}:/home/appuser/app \
-v ${PWD}/roles:/home/appuser/.ansible/roles \
-v /tmp/.test-ssh:/home/appuser/.ssh \
--rm docker:dev /bin/bash
```

### Prod

Build sans `--target dev`.

From the root of this repo:
```
docker build -t docker:prod -f ./python/ansible/docker/dockerfile .docker build -t ping:prod .
```

Now you only need to supply the ssh key for your hosts since the build target (dockerfile) copies the content of the ansible project in the container image:

```
docker run -it -v /tmp/.test-ssh:/home/appuser/.ssh \              
--rm docker:prod
```
