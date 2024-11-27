terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.116.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-springboot-react-backend"
    storage_account_name = "stjavatfstate"
    container_name       = "java"
    key                  = "springboot-react.tfstate"
  }

  required_version = "1.5.7"
}

provider "azurerm" {
  features {}
}
