variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-windows-vm"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "SouthIndia"
}

variable "vm_name" {
  description = "Name of the Windows virtual machine"
  type        = string
  default     = "vm-windows-01"
}

variable "vm_size" {
  description = "Size/SKU of the virtual machine"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Local administrator username"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Local administrator password"
  type        = string
  sensitive   = true
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "os_disk_type" {
  description = "OS disk storage account type"
  type        = string
  default     = "Premium_LRS"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "environment" {
  description = "Environment tag (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
