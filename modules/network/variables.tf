variable "location" {
    description = "Location of the network resources"
    type = string 
}
variable "resource_group_name" {
    description = "The name of the Resource Group"
    type = string
}
variable "name" {
    description = "The name of the Virtual Network"
    type = string
    default = "kalliopi-vnet"
}
variable "address_space" {
    description = "The address space of the Virtual Network"
    type = list(string)
    default = ["10.0.0.0/16"]
}
variable "webapp_subnet_prefix" {
    description = "The address prefix for the Web App Subnet"
    type = string
    default = "10.0.1.0/24"
}
variable "sql_subnet_prefix" {
    description = "The address prefix for the SQL Subnet"
    type = string
    default = "10.0.2.0/24"
}
variable "private_endpoint_subnet_prefix" {
    description = "The address prefix for the Private Endpoint Subnet"
    type = string
    default = "10.0.3.0/24"
}   
