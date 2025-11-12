#Creating an sql server
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "kalliopidemosqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "P@$$w0rd12345"
  public_network_access_enabled = true

  tags = {
    environment = "Terraform getting started"
    location    = "northeurope"
  }
}

# Allow Azure services to access the SQL server
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow all public IPs for testing (remove this in production!)
resource "azurerm_mssql_firewall_rule" "allow_all_ips" {
  name             = "AllowAllIPs"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_storage_account" "sqlstorage" {
    name                     = "kalliopidemostorageac"
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_mssql_database" "sqldatabase" {
  name      = "kalliopidemosqldb"
  server_id = azurerm_mssql_server.sqlserver.id

  tags = {
    environment = "Terraform getting started"
    location    = var.location
  }
}

# Create Private DNS Zone for SQL Server
resource "azurerm_private_dns_zone" "sql_dns_zone" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
}

# Link Private DNS Zone to Virtual Network
resource "azurerm_private_dns_zone_virtual_network_link" "sql_dns_link" {
  name                  = "sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  registration_enabled  = false
}

# Create Private Endpoint for SQL Server
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  name                = "sql-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "sql-private-connection"
    private_connection_resource_id = azurerm_mssql_server.sqlserver.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns_zone.id]
  }

  tags = {
    environment = "Terraform getting started"
  }
}