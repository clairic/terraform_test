data "azurerm_client_config" "current" {}

#Creating the key vault to store secrets
resource "azurerm_key_vault" "keyvault" {
  name                        = "kalliopidemokeyvault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  
  # Deny public access - only allow private endpoint
  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "Purge"
    ]
  }

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}

# Create private endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault_pe" {
  name                = "keyvault-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "keyvault-privateserviceconnection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}

# Create private DNS zone for Key Vault
resource "azurerm_private_dns_zone" "keyvault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = var.resource_group_name

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}

# Link private DNS zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_dns_link" {
  name                  = "keyvault-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}

# Create DNS A record for private endpoint
resource "azurerm_private_dns_a_record" "keyvault_dns_record" {
  name                = azurerm_key_vault.keyvault.name
  zone_name           = azurerm_private_dns_zone.keyvault_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.keyvault_pe.private_service_connection[0].private_ip_address]

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}
