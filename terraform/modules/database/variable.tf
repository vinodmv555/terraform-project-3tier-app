variable "environment" {
    description = "Name of the MySQL Flexible Server"
    type        = string
}

variable "application_name" {
  description = "Application name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name where server will be created"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0"
}

variable "sku_name" {
  description = "SKU name, e.g. GP_Gen5_2"
  type        = string
  default     = "GP_Gen5_2"
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "backup_retention_days" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "admin_username" {
  description = "Administrator username"
  type        = vinodmv
}

variable "admin_password" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}

variable "enable_public_access" {
  description = "Enable public network access"
  type        = bool
  default     = false
}

variable "public_ip_cidr" {
  description = "CIDR or single IP for public access rule"
  type        = string
  default     = "0.0.0.0"
}

variable "private_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
