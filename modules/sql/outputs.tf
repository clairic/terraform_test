output "sql_server_name" {
  description = "The name of the SQL Server"
  value       = azurerm_mssql_server.sqlserver.name
}
output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL Server"
  value       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}
output "storage_account_name" {
  description = "The name of the Storage Account"
  value       = azurerm_storage_account.sqlstorage.name
}
output "sql_database_name" {
    description = "The name of the SQL Database"
    value       = azurerm_mssql_database.sqldatabase.name
}
output "sql_server_id" {
    description = "The ID of the SQL Server"
    value       = azurerm_mssql_server.sqlserver.id
}
output "sql_database_id" {
    description = "The ID of the SQL Database"
    value       = azurerm_mssql_database.sqldatabase.id
}
output "storage_account_id" {
    description = "The ID of the Storage Account"
    value       = azurerm_storage_account.sqlstorage.id
}

