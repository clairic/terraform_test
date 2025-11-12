#Creating a virtual network 
resource "azurerm_network_security_group" "nsg" {
  name                = "example-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
    name = "kalliopi-vnet"
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = var.resource_group_name
}
#Creating a subnet for the sql server
resource "azurerm_subnet" "sql_subnet" {
    name                 = "sql-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.2.0/24"]
}

#Creating a subnet for the private endpoints
resource "azurerm_subnet" "private_endpoint_subnet" {
    name                 = "private-endpoint-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.3.0/24"]
}

# Create a dedicated subnet for the web app
resource "azurerm_subnet" "webapp_subnet" {
    name                 = "webapp-subnet"
    resource_group_name  = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.1.0/24"]
    
    delegation {
        name = "webapp-delegation"
        
        service_delegation {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
    }
}

