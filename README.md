# Manage Azure with Ansible in 20 minutes

## Prerequisites

* **Azure subscription**: Create a free account, [here](https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio).
* **Visual Studio Code**: Download and install, [here](https://code.visualstudio.com/Download). (Windows, MacOS, and Linux)

## Build the Ansible Dev Container

1. Clone this repository
2. Open Visual Studio Code
3. Hit Ctrl+Shift+P (Windows) Command+Shift+P (MacOS) and run the command **Remote-Containers: Open Folder in Container...**

## Create an Azure resource group

```bash
ansible localhost -m azure_rm_resourcegroup -a "name=ansible location=eastus"
```

## Deploy the Azure Environment

```bash
ansible-playbook deploy_azure_env.yml -e 'password=<password>'
```

Replace `<password>` with the desired VM's local admin password.

## Test Azure VM connectivity

```bash
ansible-playbook ping.yml
```

```bash
ansible-playbook win-ping.yml
```

## Secure passwords with ansible-vault

Use `ansible-vault` to generate an encrypted string

```bash
echo -n '<Password>' | ansible-vault encrypt_string
```

Take the output from the previous command and update the `ansible_password` value in `group_var/linux` and `group_var/windows`.

Run `ansible-inventory` to validate the encrypted password

```bash
ansible-inventory -i inventory_azure_rm.yml --graph --ask-vault-pass
```

## Configure the site webservers

Run the `site.yml` playbook.

```bash
ansible-playbook site.yml -i inventory_azure_rm.yml --ask-vault-pass
```

Once complete, curl the Azure VMs public Ip addresses to confirm the web servers installation.

```bash
windowsPublicIp=$(az vm show -d -g demo-rg -n demo-win-vm --query publicIps -o tsv);
linuxPublicIp=$(az network public-ip show -g demo-rg -n demo-linux-pip --query 'ipAddress' -o tsv);
curl $windowsPublicIp;
curl $linuxPublicIp
```