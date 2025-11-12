variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "location" {
    description = "Location of the web app"
    type = string 
}
variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}
variable "app_service_name" {
  description = "The name of the App Service"
  type        = string
}
variable "sku_name" {
    description = "The SKU name for the App Service Plan"
    type = string
    default = "S1"
}
variable "sku_tier" {
    description = "The SKU tier for the App Service Plan"
    type = string
    default = "Standard"
}
variable "app_service_plan_id"{
    description = "The ID of the App Service Plan"
    type = string
}