output "virtual_network_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "webapp_subnet_id" {
  description = "The ID of the Web App Subnet"
  value       = azurerm_subnet.webapp_subnet.id
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = azurerm_network_security_group.nsg.id
}
