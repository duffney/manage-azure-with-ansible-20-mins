#create a resource group
ansible localhost -m azure_rm_resourcegroup -a "name=demo-rg location=eastus"

# Test Linux VM connectivity
#publicIP=
linuxPublicIp=$(az network public-ip show -g demo-rg -n demo-linux-pip --query 'ipAddress' -o tsv);
ansible all -m ping -i "${linuxPublicIp}," -e "ansible_user=azureuser ansible_password=${password} ansible_ssh_common_args='-o StrictHostKeyChecking=no'"

# # Test Windows VM connectivity
# ansible all -i <publicIp>, -m win_ping -e "ansible_user=azureuser ansible_password=<Password> ansible_winrm_server_cert_validation=ignore ansible_connection=winrm"

windowsPublicIp=$(az vm show -d -g demo-rg -n demo-win-vm --query publicIps -o tsv);
ansible all -i "${windowsPublicIp}," -m win_ping -e "ansible_user=azureuser ansible_password=${password} ansible_winrm_server_cert_validation=ignore ansible_connection=winrm"

#encrypt a string
echo -n '<Password>' | ansible-vault encrypt_string

#show inventory
ansible-inventory -i inventory_azure_rm.yml --graph --ask-vault-pass

#Remove all Azure resources
ansible localhost -m azure_rm_resourcegroup -a "name=demo-rg state=absent force_delete_nonempty=yes"