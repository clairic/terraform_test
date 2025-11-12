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