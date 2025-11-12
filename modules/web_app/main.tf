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
}