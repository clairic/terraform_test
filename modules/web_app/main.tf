# Create an App Service plan with Standard tier
resource "azurerm_service_plan" "rg" {
    name                = var.app_service_plan_name
    location            = var.location
    resource_group_name = var.resource_group_name
    os_type             = "Linux"
    sku_name            = "S1"
}

# Create an App Service
resource "azurerm_app_service" "rg" {
  name                = "Kalliopi-Tsiampa-AppService"
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Server=tcp:${var.sql_server_fqdn},1433;Initial Catalog=${var.sql_database_name};Persist Security Info=False;User ID=${var.sql_admin_username};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

# VNet Integration for the App Service
resource "azurerm_app_service_virtual_network_swift_connection" "vnet_integration" {
  app_service_id = azurerm_app_service.rg.id
  subnet_id      = var.subnet_id
}