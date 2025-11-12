#Creating an sql server
resource "azurerm_mssql_server" "sqlserver"{
    name = "kalliopidemosqlserver"
    resource_group_name = var.resource_group_name
    location = var.location
    version = "12.0"
    administrator_login = "sqladminuser"
    administrator_login_password = "P@$$w0rd12345"

    tags = {
        environment = "Terraform getting started"
        location = "northeurope"
    }
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
        location = var.location
    }
}