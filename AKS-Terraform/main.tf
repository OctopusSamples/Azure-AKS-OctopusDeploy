terraform {
  backend "azurerm" {
    resource_group_name  = "MichaelLevanResources"
    storage_account_name = "odstorage92"
    container_name       = "tfstate"
    key                  = "terraform.state"
  }
}

provider "azurerm" {
  version = "<=2.36.0"

  features {}
}

data "azurerm_key_vault_secret" "keyVaultClientID" {
  name         = "ODClientID"
  key_vault_id = var.keyvaultID
}

data "azurerm_key_vault_secret" "keyVaultClientSecret" {
  name         = "ODClientSecret"
  key_vault_id = var.keyvaultID
}

resource "azurerm_kubernetes_cluster" "OD-AKS" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resourceGroup
  dns_prefix          = "octopusdeployprefix"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }
  service_principal {
    client_id     = data.azurerm_key_vault_secret.keyVaultClientID.value
    client_secret = data.azurerm_key_vault_secret.keyVaultClientSecret.value
  }
}
