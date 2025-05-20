# Resoruce Group Variables 
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

# Network Variables
variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets with name and CIDR"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "allowed_ports" {
  type        = map(string)
  description = "List of ports to allow in the NSG"
}

variable "compute_subnet_name" {
  description = "Name of the subnet to associate NSG with"
  type        = string
}

# Bastion Variable
variable "enable_bastion" {
  description = "Whether to create a Bastion host"
  type        = bool
  default     = false
}

# DB Variables 
variable "db_subnet_name" {
  description = "Name of the subnet to host the DB Private Endpoint"
  type        = string
}

variable "db_nsg_name" {
  description = "Name to give the NSG for the DB subnet"
  type        = string
}

variable "db_allowed_ports" {
  description = "Port ranges to allow into the DB subnet"
  type        = map(string)
  # e.g. { mysql = "3306" }
}

