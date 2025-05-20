output "vm_id" {
    description = "The ID of the VM"
    value = azurerm_linux_virtual_machine.vm_webapp.id
}

output "vm_nic_id" {
    description = "The ID of the network interface"
    value = azurerm_network_interface.nic_vm_webapp.id
}

output "private_ip" {
    description = "The private IP address of the VM"
    value = azurerm_network_interface.nic_vm_webapp.ip_configuration[0].private_ip_address
}

output "public_ip_address" {
  description = "The public IP address, if created"
  value =  var.enable_public_ip ? azurerm_public_ip.pip_vm_webapp : null
}