
output "app_service_plan_name" {
  description = "The name of the App Service Plan"
  value       = azurerm_service_plan.rg.name
}
output "app_service_plan_location" {
  description = "The location of the App Service Plan"
  value       = azurerm_service_plan.rg.location
}
output "app_service_name" {
  description = "The name of the App Service"
  value       = azurerm_app_service.rg.name
}
output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.rg.id
}
output "app_service_default_hostname" {
  value = azurerm_app_service.rg.default_site_hostname
}

