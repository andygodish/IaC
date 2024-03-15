FROM python:3.12-slim-bookworm

ARG UID=1000
ARG GID=1000

RUN useradd -ms /bin/bash -u $UID appuser

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends openssh-client sshpass && \
    apt autoremove -y && \
    apt clean -y && \
    rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

WORKDIR /app
RUN chown appuser:appuser /app

RUN mkdir /scripts && chown -R appuser:appuser /scripts
RUN mkdir /config && chown -R appuser:appuser /config

COPY --chown=appuser:appuser ./ansible.cfg /config
COPY --chown=appuser:appuser ./hosts.ini.example /config
COPY --chown=appuser:appuser ./bootstrap-new-playbook.sh /scripts

RUN chmod +x /scripts/bootstrap-new-playbook.sh

USER appuser

RUN pip install pip --upgrade

# --user configures for the current user instead of root: "pip install --user ansible"
RUN pip install --user ansible

ENV PATH="/home/appuser/.local/bin:${PATH}"

# Additional Ansible configuration
RUN mkdir -p /home/appuser/.ssh && \
    mkdir -p /home/appuser/.ansible/roles /home/appuser/.ansible/tmp 


