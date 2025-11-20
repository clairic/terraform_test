variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "object_id" {
  description = "The Object ID of the user or service principal to assign access policies. Required for Key Vault access."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet for private endpoints"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network"
  type        = string
}