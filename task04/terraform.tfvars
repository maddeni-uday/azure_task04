location            = "East US"
resource_group_name = "cmaz-93253787-mod4-rg"
vnet_name           = "cmaz-93253787-mod4-vnet"
subnet_name         = "frontend"
nsg_name            = "cmaz-93253787-mod4-nsg"
nic_name            = "cmaz-93253787-mod4-nic"
public_ip_name      = "cmaz-93253787-mod4-pip"
dns_name_label      = "cmaz-93253787-mod4-nginx"
vm_name             = "cmaz-93253787-mod4-vm"
vm_sku              = "Standard_F2s_v2"
allow_http          = "AllowHTTP"
allow_ssh           = "AllowSSH"

tags = {
  Creator = "maddeni_uday@epam.com"
}
