
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

# Get current Azure client configuration
data "azurerm_client_config" "current" {}

# Get the current user's object ID from Azure AD
data "external" "current_user_object_id" {
  program = ["powershell", "-Command", "az ad signed-in-user show --query '{object_id: id}' -o json"]
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-kalliopi-tsiampa"
  location = "northeurope"
}

# Call the network module first to get subnet and VNet IDs
module "network" {
  source = "./modules/network"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

#Call the keyvault module
module "keyvault" {
  source = "./modules/keyvault"

  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  object_id                  = data.external.current_user_object_id.result.object_id
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  virtual_network_id         = module.network.virtual_network_id

  depends_on = [module.network]
}

# Generate random SQL admin username
resource "random_string" "sql_admin_username" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Generate random SQL admin password
resource "random_password" "sql_admin_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
}

# Store SQL username in Key Vault
resource "azurerm_key_vault_secret" "sql_username" {
  name         = "sql-admin-username"
  value        = random_string.sql_admin_username.result
  key_vault_id = module.keyvault.azurerm_key_vault_id

  depends_on = [module.keyvault]
}

# Store SQL password in Key Vault
resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  value        = random_password.sql_admin_password.result
  key_vault_id = module.keyvault.azurerm_key_vault_id

  depends_on = [module.keyvault]
}

# Call the sql module 
module "sql" {
  source = "./modules/sql"

  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  virtual_network_id         = module.network.virtual_network_id
  sql_admin_username         = random_string.sql_admin_username.result
  sql_admin_password         = random_password.sql_admin_password.result

  depends_on = [azurerm_key_vault_secret.sql_username, azurerm_key_vault_secret.sql_password]
}

# Call the web_app module
module "web_app" {
  source = "./modules/web_app"

  app_service_plan_name = "Kalliopi-Tsiampa-AppServicePlan"
  app_service_name      = "Kalliopi-Tsiampa-AppService"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  app_service_plan_id   = module.web_app.app_service_plan_id
  subnet_id             = module.network.webapp_subnet_id
  sql_server_fqdn       = module.sql.sql_server_fqdn
  sql_database_name     = module.sql.sql_database_name
  sql_admin_username    = random_string.sql_admin_username.result
  sql_admin_password    = random_password.sql_admin_password.result
}

# Outputs for Key Vault information
output "key_vault_name" {
  description = "The name of the Key Vault containing SQL credentials"
  value       = module.keyvault.azurerm_key_vault_name
}

output "sql_username_secret_name" {
  description = "The name of the Key Vault secret containing SQL username"
  value       = azurerm_key_vault_secret.sql_username.name
}

output "sql_password_secret_name" {
  description = "The name of the Key Vault secret containing SQL password"
  value       = azurerm_key_vault_secret.sql_password.name
}

output "powershell_retrieve_username_command" {
  description = "PowerShell command to retrieve SQL username"
  value       = "az keyvault secret show --name ${azurerm_key_vault_secret.sql_username.name} --vault-name ${module.keyvault.azurerm_key_vault_name} --query value -o tsv"
}

output "powershell_retrieve_password_command" {
  description = "PowerShell command to retrieve SQL password"
  value       = "az keyvault secret show --name ${azurerm_key_vault_secret.sql_password.name} --vault-name ${module.keyvault.azurerm_key_vault_name} --query value -o tsv"
}