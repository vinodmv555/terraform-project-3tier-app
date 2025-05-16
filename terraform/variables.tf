variable "rg_name" {
  description = "Resoruce Group Name"
  type        = string
  default     = "rg-myapp"
}

variable "environment" {
  description = "Environment type"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Resource group location"
  type        = string
  default     = "eastus"
}
