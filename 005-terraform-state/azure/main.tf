resource "random_string" "this" {
  length  = 12
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_storage_account" "this" {
  name                              = "tfstate${resource.random_string.this.result}"
  resource_group_name               = data.azurerm_resource_group.this.name
  location                          = data.azurerm_resource_group.this.location
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  public_network_access_enabled     = true
  infrastructure_encryption_enabled = true

  tags = {
    profile = "tfstate-${var.name}",
  }
}

resource "azurerm_storage_container" "this" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "blob"
}
