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
  location            = azurerm_resource_group.rg.location # Reference the Resource Group
  resource_group_name = azurerm_resource_group.rg.name     # Reference the Resource Group
  tags                = var.tags
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name    # Reference the Resource Group
  virtual_network_name = azurerm_virtual_network.vnet.name # Reference the Virtual Network
  address_prefixes     = var.address_prefixes
}

# Public IP
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  resource_group_name = azurerm_resource_group.rg.name     # Reference the Resource Group
  location            = azurerm_resource_group.rg.location # Reference the Resource Group
  allocation_method   = var.allocation_method
  domain_name_label   = var.dns_name_label
  tags                = var.tags
}

# Network Security Group
resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = azurerm_resource_group.rg.name     # Reference the Resource Group
  location            = azurerm_resource_group.rg.location # Reference the Resource Group
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
  resource_group_name         = azurerm_resource_group.rg.name          # Reference the Resource Group
  network_security_group_name = azurerm_network_security_group.nsg.name # Reference the NSG
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
  resource_group_name         = azurerm_resource_group.rg.name          # Reference the Resource Group
  network_security_group_name = azurerm_network_security_group.nsg.name # Reference the NSG
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  resource_group_name = azurerm_resource_group.rg.name     # Reference the Resource Group
  location            = azurerm_resource_group.rg.location # Reference the Resource Group
  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = azurerm_subnet.subnet.id # Reference the Subnet
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id # Reference the Public IP
  }
  tags = var.tags
}

# Associate NSG to NIC
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id      # Reference the Network Interface
  network_security_group_id = azurerm_network_security_group.nsg.id # Reference the Network Security Group
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name     # Reference the Resource Group
  location              = azurerm_resource_group.rg.location # Reference the Resource Group
  size                  = var.vm_sku
  admin_username        = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.nic.id] # Reference the Network Interface
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "24_04-lts"
    version   = "latest"
  }
  tags = var.tags

  # SSH Key Authentication
  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = var.admin_ssh_key
  }

  provisioner "remote-exec" {
    connection {
      host        = azurerm_public_ip.pip.ip_address # Reference the Public IP
      port        = 22
      user        = var.vm_admin_username
      private_key = file("~/.ssh/id_rsa") # Path to your private SSH key
    }

    inline = var.nginx_install_command
  }
}
