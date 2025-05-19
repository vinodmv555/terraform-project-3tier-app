output "vnet_id" {
  description = "Vnet ID"
  value       = azurerm_virtual_network.vnet_webapp.id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for k, v in azurerm_subnet.subnets_webapp_vnet : k => v.id }
}

output "compute_nsg_id" {
  description = "Compute Subnet ID"
  value = azurerm_network_security_group.nsg_compute_subnet.id 
}

output "db_nsg_id" {
  description = "DB subnet ID"
  value = azurerm_network_security_group.nsg_db_subnet.id   
}

output "resoruce_group_name" {
  description = "Name of network security group"
  value       = azurerm_resource_group.rg_webapp.name
}

output "resoruce_group_location" {
  description = "Name of network security group location"
  value       = azurerm_resource_group.rg_webapp.location
}