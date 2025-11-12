
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}
# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-kalliopi-tsiampa"
  location = "northeurope"
}

# Call the network module
module "network" {
  source = "./modules/network"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Call the web_app module
module "web_app" {
  source = "./modules/web_app"

  app_service_plan_name = "Kalliopi-Tsiampa-AppServicePlan"
  app_service_name      = "Kalliopi-Tsiampa-AppService"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  app_service_plan_id   = module.web_app.app_service_plan_id
  subnet_id             = module.network.webapp_subnet_id
}
