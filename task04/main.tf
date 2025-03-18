# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.address_prefixes
}

# Public IP
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = var.allocation_method
  domain_name_label   = var.dns_name_label
  tags                = var.tags
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

# NSG Rule for SSH
resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = var.allow_ssh
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# NSG Rule for HTTP
resource "azurerm_network_security_rule" "allow_http" {
  name                        = var.allow_http
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
  tags = var.tags
}

# Associate NSG to NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Virtual Machine Resource
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_sku
  admin_username        = var.vm_admin_username              # Username provided in configuration
  admin_password        = var.vm_password                    # Password passed externally (not hardcoded in terraform.tfvars)
  network_interface_ids = [azurerm_network_interface.nic.id] # NIC association

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"        # Correct case for publisher
    offer     = "ubuntu-24_04-lts" # Correct offer name
    sku       = "server"           # Correct SKU
    version   = "latest"
  }

  disable_password_authentication = false # Password authentication enabled

  tags = var.tags

  # Provisioner for NGINX Installation
  provisioner "remote-exec" {
    connection {
      host     = azurerm_public_ip.pip.ip_address
      port     = 22
      user     = var.vm_admin_username
      password = var.vm_password # Password dynamically supplied during execution
    }

    inline = var.nginx_install_command
  }
}
