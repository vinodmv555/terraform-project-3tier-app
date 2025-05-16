output "vnet_id" {
  description = "Vnet ID"
  value       = azurerm_virtual_network.app_vnet.id
}

output "subnet_ids" {
  description = "Subnet IDs"
  value       = { for k, v in azurerm_subnet.app_subnets : k => v.id }
}

output "nsg_id" {
  value = azurerm_network_security_group.app_nsg.id
}