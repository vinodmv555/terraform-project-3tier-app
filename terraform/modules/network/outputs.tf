output "vnet_id" {
    description = "Vnet ID"
    value = azurerm_virtual_network.app_vnet.id
}

output "subnet_ids" {
    description = "Subnet IDs"
    value = { for k, v in azurerm_subnet.app_subnets : k => v.id}
}

output "nsg_id" {
  value = length(azurerm_network_security_group.main) > 0 ? azurerm_network_security_group.main[0].id : null
}