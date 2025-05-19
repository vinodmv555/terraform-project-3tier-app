terraform {
  required_version = "~> 1.12.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.28.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "2c58f186-d2f5-4a88-b700-e54dd3526d6d"
  features {}
}


module "network" {
  environment        = "dev"
  application_name   = "mywebapp"
  source             = "./modules/network"
  location           = "centralus"
  vnet_address_space = ["10.0.0.0/16"]

  subnets = [
    {
      name           = "compute-subnet"
      address_prefix = "10.0.2.0/24"
    },
    {
      name           = "AzureBastionSubnet"
      address_prefix = "10.0.3.0/24"
    },
    {
      name           = "db-subnet"
      address_prefix = "10.0.4.0/24"
    }
  ]

  enable_bastion      = false
  bastion_name        = "bastion-dev"
  nsg_name            = "allow-22-80-443" # to changed nsg-compute-subnet
  compute_subnet_name = "compute-subnet"
  allowed_ports = {
    "ssh"   = "22",
    "http"  = "80",
    "https" = "443"
  }
  db_subnet_name = "db-subnet"
  db_nsg_name    = "nsg-db-subnet"
  db_allowed_ports = {
    "mysql" = ", "
  }
}



module "compute" {
  source              = "./modules/compute"

  resource_group_name = module.network.resoruce_group_name # ok 
  location            = module.network.resoruce_group_location # ok 

  environment      = "dev" # ok 
  application_name = "mywebapp" # ok 
  vm_name          = "web01" # ok 

  enable_public_ip = true
  public_ip_sku    = "Standard"
  
  subnet_id = module.network.subnet_ids["compute-subnet"] # ok and issue  
  
}