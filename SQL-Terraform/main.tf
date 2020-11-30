provider "azurerm" {
  version = "<=2.36.0"

  features {}
}

resource "azurerm_mssql_server" "octopussqlserver" {
  name                         = "octopussqlprod"
  resource_group_name          = var.resourceGroupName
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqlLogin
  administrator_login_password = var.dbpassword
  minimum_tls_version          = "1.2"
}

resource "azurerm_sql_firewall_rule" "acifirewallrule" {
  name                = "azurecontainerinstanceconnection"
  resource_group_name = var.resourceGroupName
  server_name         = azurerm_mssql_server.octopussqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"

  depends_on = [azurerm_mssql_server.octopussqlserver]
}

resource "azurerm_mssql_database" "octopussqldb" {
  name           = "octopusdb"
  server_id      = azurerm_mssql_server.octopussqlserver.id
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "BC_Gen5_2"
  zone_redundant = true
}