# TODO: This should be created by a previous stage
# For now lab is manually created
data "azurerm_resource_group" "this" {
  name = var.name
}
