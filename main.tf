
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

# Call the sql module 
module "sql" {
  source = "./modules/sql"

  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  virtual_network_id         = module.network.virtual_network_id
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
  sql_server_fqdn       = module.sql.sql_server_fqdn
  sql_database_name     = module.sql.sql_database_name
  sql_admin_username    = "sqladminuser"
  sql_admin_password    = "P@$$w0rd12345"
}