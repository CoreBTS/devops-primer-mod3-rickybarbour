#resource "random_pet" "rg_name" {
#  prefix = var.resource_group_name_prefix
#}

data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "secret-rickylab" {
    name = azurerm_key_vault.kv-rickylab.name
    resource_group_name = azurerm_resource_group.rg-rickylab.name
}

resource "azurerm_resource_group" "rg-rickylab" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_service_plan" "asp-simple" {
  name                = var.app_serviceplan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.asp_sku_name
  depends_on = [
    azurerm_resource_group.rg-rickylab
  ]  
}

resource "azurerm_linux_web_app" "app-simple" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp-simple.id
  app_settings = {
    APP_SECRET = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault.kv-rickylab.vault_uri}secrets/${azurerm_key_vault_secret.secret-rickylab.name}/${azurerm_key_vault_secret.secret-rickylab.version})"
  }

  identity {
    type = "SystemAssigned"
  }

  site_config {
   application_stack {
    java_server = "JAVA"
    java_version = "java17"   
    java_server_version = "17"
  }
 }
}  

resource "random_password" "kv_app_secret" {
  length  = 12
  special = true
}

resource "azurerm_key_vault" "kv-rickylab" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
  enabled_for_template_deployment = true

  depends_on = [
    azurerm_resource_group.rg-rickylab
  ]
}

resource "azurerm_key_vault_access_policy" "ap02-rickylab" {
  key_vault_id = azurerm_key_vault.kv-rickylab.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id   #"026b5ff1-a720-4c34-a8cf-8981550f97b4"

  secret_permissions = [
    "Get",
    "Set",
    "Recover",
    "Delete",
    "Purge"
  ]
  
}

resource "azurerm_key_vault_access_policy" "ap01-rickylab" {
  key_vault_id = azurerm_key_vault.kv-rickylab.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.app-simple.identity.0.principal_id

  secret_permissions = [
    "Get",
  ]

}

resource "azurerm_key_vault_access_policy" "ap03-rickylab" {
  object_name = "CoreBTS NOC and SD Staff"
  key_vault_id = azurerm_key_vault.kv-rickylab.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "322964b9-c289-48a8-815c-78ccbd73e4e0"
  condition    = var.asp_sku_name == "S1"

  secret_permissions = [
    "Get",
    "List"
  ]

}

resource "azurerm_key_vault_secret" "secret-rickylab" {
  name         = var.secret_name
  value        = random_password.kv_app_secret.result
  key_vault_id = azurerm_key_vault.kv-rickylab.id

  depends_on = [
    azurerm_key_vault_access_policy.ap02-rickylab
  ]

}
