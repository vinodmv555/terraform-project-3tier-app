# Azure Resource Group
resource "azurerm_resource_group" "app_rg" {
    name = "rg-${var.environment}-${var.vnet_name}"
    location = var.location
}

# Azure Virtual Network 
resource "azurerm_virtual_network" "app_vnet" {
    name = "vnet-${var.environment}-${var.vnet_name}"
    location = azurerm_resource_group.app_rg.location
    resource_group_name = azurerm_resource_group.app_rg.name 
    address_space = var.vnet_address_space    
}

# Subnets
resource "azurerm_subnet" "app_subnets" {
    for_each = { for subnet in var.subnets : subnet.name => subnet }

    name = each.value.name
    resource_group_name = azurerm_resource_group.app_rg.name
    virtual_network_name = azurerm_virtual_network.app_vnet.name
    address_prefixes = [ each.value.address_prefix ]
}

# NSG 
resource "azurerm_network_security_group" "app_nsg" {
    name = var.nsg_name
    location = azurerm_resource_group.app_rg.name
    resource_group_name = azurerm_resource_group.app_rg.location 
}

# NSG rules
resource "azurerm_network_security_rule" "app_nsg_rules" {
    for_each = var.allowed_ports

    name =  "allow-${each.key}"
    priority                    = 100 + index(keys(var.allowed_ports), each.key)
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "*"
    source_port_range           = "*"
    destination_port_range      = each.value
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.app_rg.name
    network_security_group_name = azurerm_network_security_group.app_nsg.name
}

# NSG Association 
resource "azurerm_subnet_network_security_group_association" "app_nsg_assocation" {
  subnet_id = var.nsg_subnet_name
  network_security_group_id = azurerm_network_security_group.app_nsg.id
}

resource "azurerm_public_ip" "app_vnet_bastion" {
    count = var.enable_bastion ? 1: 0
    name = "${var.bastion_name}-pip"
    location = azurerm_resource_group.app_rg.location
    resource_group_name = azurerm_resource_group.app_rg.name
    allocation_method = "Static"
    sku = "Standard"  
}

resource "azurerm_bastion_host" "app_vnet_bastion" {
    count = var.enable_bastion ? 1: 0
    name = var.bastion_name
    location = azurerm_resource_group.app_rg.location
    resource_group_name = azurerm_network_security_group.app_nsg.name

    ip_configuration {
      name = "bastion-ip-config"
      subnet_id = azurerm_subnet.app_subnets["AzureBastionSubnet"].id
      public_ip_address_id = azurerm_public_ip.app_vnet_bastion[0].id
    }  
}