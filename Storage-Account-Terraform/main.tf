provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "od-tfstate-storage" {
  name = var.storageAccountName
  resource_group_name = var.resourceGroupName

  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_container" "od-tfstate-container" {
  name = "tfstate"
  storage_account_name = azurerm_storage_account.od-tfstate-storage.name
  container_access_type = "private"
}