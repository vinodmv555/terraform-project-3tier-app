terraform {
  required_version = ">= 1.11.0"
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