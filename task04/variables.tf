variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
}

variable "address_prefixes" {
  description = "Address prefixes for the Subnet"
  type        = list(string)
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "nic_name" {
  description = "Name of the Network Interface"
  type        = string
}

variable "public_ip_name" {
  description = "Name of the Public IP resource"
  type        = string
}

variable "dns_name_label" {
  description = "DNS name label for the Public IP resource"
  type        = string
}

variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}

variable "vm_sku" {
  description = "SKU for the Virtual Machine"
  type        = string
}

variable "vm_admin_username" {
  description = "Admin username for the Virtual Machine"
  type        = string
  default     = "azureuser"
}

variable "allocation_method" {
  description = "Public IP allocation method"
  type        = string
}

variable "nic_ip_configuration_name" {
  description = "Name for the NIC IP configuration"
  type        = string
}

variable "nginx_install_command" {
  description = "Commands to install and configure NGINX"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}

variable "allow_http" {
  description = "Rule name for AllowHTTP NSG rule"
  type        = string
}

variable "allow_ssh" {
  description = "Rule name for AllowSSH NSG rule"
  type        = string
}
