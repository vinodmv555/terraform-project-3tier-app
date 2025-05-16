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
  environment         = "dev"  
  application_name    = "mywebapp"
  source              = "./modules/network"
  location            = "eastus"
  vnet_address_space  = ["10.0.0.0/16"]
  subnets = [
    {
      name           = "compute"
      address_prefix = "10.0.2.0/24"
    },
    {
      name           = "AzureBastionSubnet"
      address_prefix = "10.0.3.0/27"
    }
  ]
  enable_bastion  = false
  bastion_name    = "bastion-dev"
  nsg_name        = "allow-22-80-443"
  nsg_subnet_name = "compute"
  allowed_ports = {
    "ssh"   = "22",
    "http"  = "80",
    "https" = "443"
  }
}