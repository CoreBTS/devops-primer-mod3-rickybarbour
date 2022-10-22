output "resource_group_name" {
  value = azurerm_resource_group.rg-rickylab.name
}

output "keyvault" {
    value = data.azurerm_key_vault.secret-rickylab.name
}
