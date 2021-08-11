FROM ubuntu:21.04

ENV ANSIBLE_VERSION 2.10.5

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y openssh-client sshpass curl wget apt-transport-https lsb-release python3-pip git; \
    apt-get clean

RUN pip3 install --upgrade pip; \
    pip3 install "ansible==${ANSIBLE_VERSION}" ansible-lint pywinrm>=0.3.0; \
    wget -q https://raw.githubusercontent.com/ansible-collections/azure/dev/requirements-azure.txt; \
    pip3 install -r requirements-azure.txt; \
    rm requirements-azure.txt; \
    ansible-galaxy collection install azure.azcollection; \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash

COPY .bashrc /root/.bashrc