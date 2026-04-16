terraform {
  required_version = ">= 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "pulsestack-rg"
    storage_account_name = "pulsestacktfstate"
    container_name       = "tfstate"
    key                  = "pulsestack.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.networking.subnet_id
  ssh_public_key      = var.admin_ssh_key
}