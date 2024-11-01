resource "vault_kv_secret_v2" "terraform_state_store" {
  mount               = "secret"
  name                = "multi-cloud/azure/${var.profile}/terraform_state_store"
  cas                 = 1
  delete_all_versions = true

  data_json = jsonencode({
    "azurerm_storage_account_id"   = resource.azurerm_storage_account.this.id,
    "azurerm_storage_container_id" = resource.azurerm_storage_container.this.id
  })

  custom_metadata {
    max_versions = 5
    data = {
      profile = var.profile,
    }
  }
}
