variable "resource_group_name" {
  description = "Name of the resoruce group"
  type        = string
}

variable "environment" {
  description = "Infra environment"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual netwok"
  type        = string
}

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

variable "enable_bastion" {
  description = "Whether to create a Bastion host"
  type        = bool
  default     = false
}

# This variable is optional – the caller of the module doesn’t have to explicitly pass it.
variable "bastion_name" {
  description = "Name of the Bastion host (only used if enable_bastion is true)"
  type        = string
  default     = ""
}

variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}

variable "allowed_ports" {
  type        = map(string)
  description = "List of ports to allow in the NSG"
}

variable "nsg_subnet_name" {
  description = "Name of the subnet to associate NSG with"
  type        = string
}
