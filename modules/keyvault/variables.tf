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