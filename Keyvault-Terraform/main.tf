provider "azurerm" {
  version = "<=2.36.0"

  features {}
}

resource "azurerm_key_vault" "od-keyvault" {
  name                = "od-keyvault-aks"
  resource_group_name = var.resourceGroupName
  location            = var.location
  sku_name            = "standard"
  tenant_id           = var.tenantID

  access_policy {
    tenant_id = var.tenantID
    object_id = var.objectID

    key_permissions = [
      "get",
      "list",
      "create",
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
    ]
  }

  access_policy {
    tenant_id = var.tenantID
    object_id = var.localObjectID

    key_permissions = [
      "get",
      "list",
      "create",
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
    ]
  }
}

resource "azurerm_key_vault_secret" "od-clientid" {
  name         = "ODClientID"
  value        = var.clientID
  key_vault_id = azurerm_key_vault.od-keyvault.id
}

resource "azurerm_key_vault_secret" "od-client-password" {
  name         = "ODClientSecret"
  value        = var.clientSecret
  key_vault_id = azurerm_key_vault.od-keyvault.id
}

output "key_vault_id" {
  value = azurerm_key_vault.od-keyvault.id
}
