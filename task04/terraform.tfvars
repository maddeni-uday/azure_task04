# General Configuration
location            = "East US"
resource_group_name = "cmaz-93253787-mod4-rg"
vnet_name           = "cmaz-93253787-mod4-vnet"
subnet_name         = "frontend"

address_space    = ["10.0.0.0/16"]
address_prefixes = ["10.0.1.0/24"]

nsg_name       = "cmaz-93253787-mod4-nsg"
nic_name       = "cmaz-93253787-mod4-nic"
public_ip_name = "cmaz-93253787-mod4-pip"
dns_name_label = "cmaz-93253787-mod4-nginx"
vm_name        = "cmaz-93253787-mod4-vm"
vm_sku         = "Standard_F2s_v2"

allocation_method         = "Static"
nic_ip_configuration_name = "nic-ip-config"

tags = {
  Creator = "maddeni_uday@epam.com"
}

# Network Security Rules
allow_http = "AllowHTTP"
allow_ssh  = "AllowSSH"

# SSH Keys
admin_ssh_key   = "ssh-rsa AAAAB3N...your-public-key..." # Provide a valid public SSH key here
ssh_private_key = <<EOT
-----BEGIN RSA PRIVATE KEY-----
MIIBOgIBAAJBALD...your-private-key...
-----END RSA PRIVATE KEY-----
EOT

# NGINX Installation
nginx_install_command = [
  "sudo apt-get update -y",
  "sudo apt-get install nginx -y",
  "sudo systemctl start nginx",
  "sudo systemctl enable nginx"
]
