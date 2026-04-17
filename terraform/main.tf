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
    subscription_id = "68129bb7-e267-4852-b7ac-ddbf414229ff"
  }
}

provider "azurerm" {
  features {}
  tenant_id = "7f03ac40-ab26-47f5-88c3-95ba4ed359d5"
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