terraform {
  required_version = "~> 1.12.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.28.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-backends"
    storage_account_name = "terraformbackends286957"
    container_name       = "terraform-backend-myapp"
    key                  = "webapp.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = "2c58f186-d2f5-4a88-b700-e54dd3526d6d"
  features {}
}


module "network" {
  environment        = var.environment
  application_name   = var.application_name
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
  nsg_name            = "nsg-compute-subnet" # to changed nsg-compute-subnet
  compute_subnet_name = "compute-subnet"
  allowed_ports = {
    "ssh"   = "22",
    "http"  = "80",
    "https" = "443"
  }
  db_subnet_name = "db-subnet"
  db_nsg_name    = "nsg-db-subnet"
  db_allowed_ports = {
    "mysql" = "3306"
  }
}

module "compute" {
  source = "./modules/compute"

  resource_group_name = module.network.resoruce_group_name
  location            = module.network.resoruce_group_location

  environment      = var.environment
  application_name = var.application_name
  vm_name          = var.vm_name

  enable_public_ip = true
  public_ip_sku    = "Standard"

  subnet_id = module.network.subnet_ids["compute-subnet"] 

}