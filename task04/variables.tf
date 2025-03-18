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
}

variable "vm_password" {
  description = "Admin password for the Virtual Machine (sensitive)"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
}