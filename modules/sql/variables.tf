variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
}
variable "location" {
  description = "Location of the SQL resources"
  type        = string
}
variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet for private endpoints"
  type        = string
}
variable "virtual_network_id" {
  description = "The ID of the Virtual Network"
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
