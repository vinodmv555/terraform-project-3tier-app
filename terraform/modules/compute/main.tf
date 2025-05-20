# Public IP
resource "azurerm_public_ip" "pip_vm_webapp" {
    count = var.enable_public_ip ? 1: 0
    name = "pip-${var.environment}-${var.application_name}-${var.vm_name}"
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    sku = var.public_ip_sku
}

# Network Interface 
resource "azurerm_network_interface" "nic_vm_webapp" {
    name = "nic-${var.environment}-${var.application_name}-${var.vm_name}"
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
      name = "ipconfig1"
      subnet_id = var.subnet_id
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = var.enable_public_ip ? azurerm_public_ip.pip_vm_webapp[0].id : null
    }  
}

# Virtual machine 
resource "azurerm_linux_virtual_machine" "vm_webapp" {
    name = "vm-${var.environment}-${var.application_name}-${var.vm_name}"
    resource_group_name = var.resource_group_name
    location = var.location
    size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.nic_vm_webapp.id ]
    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = var.image_publisher
      offer = var.image_offer
      sku = var.image_sku
      version = var.image_version
    }

    tags = {
      env = var.environment
      application_name = var.application_name
      crated_by = "Terraform"
    }
  
}