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
variable "subnet_id" {
  description = "The ID of the subnet for VNet integration"
  type        = string
}
variable "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  type        = string
}
variable "sql_database_name" {
  description = "The name of the SQL Database"
  type        = string
}
variable "sql_admin_username" {
  description = "The SQL Server administrator username"
  type        = string
}
variable "sql_admin_password" {
  description = "The SQL Server administrator password"
  type        = string
  sensitive   = true
}