terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 1.5.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "StateRG"
    storage_account_name = "statefileacc1990"   # must be globally unique
    container_name       = "tfstate"
    key                  = "azure-windows-vm/terraform.tfstate"
  }
}
