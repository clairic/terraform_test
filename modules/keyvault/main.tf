data "azurerm_client_config" "current" {}

#Creating the key vault to store secrets
resource "azurerm_key_vault" "keyvault" {
  name                        = "kalliopidemokeyvault"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7

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
      "Restore"
    ]
  }

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}
