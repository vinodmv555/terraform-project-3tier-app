variable "environment" {
  description = "Infra environment"
  type        = string
}

variable "application_name" {
  description = "Application name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resoruce group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet where VM nic will be placed"
  type        = string
}

variable "vm_name" {
  description = "Base name for the VM"
  type        = string
}

variable "vm_size" {
  description = "Size of the VM (e.g. Standard_B2ms)"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "image_publisher" {
  description = "OS image publisher (e.g. Canonical)"
  type        = string
  default     = "RedHat"
}

variable "image_offer" {
  description = "OS image offer (e.g. UbuntuServer)"
  type        = string
  default     = "RHEL"
}

variable "image_sku" {
  description = "OS image SKU (e.g. 18.04-LTS)"
  type        = string
  default     = "83-gen2"
}

variable "image_version" {
  description = "OS image version (e.g. latest)"
  type        = string
  default     = "latest"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "SSH public key for login"
  type        = string
  default = "Jenkins_2019_Admin#2345"
}

variable "enable_public_ip" {
  description = "Whether to create and attach a public IP"
  type        = bool
  default     = false
}

variable "public_ip_sku" {
  description = "SKU for the public IP if enabled"
  type        = string
  default     = "Basic"
}
