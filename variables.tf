variable "location" {
  default     = "eastus2"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  default     = "rg-rb-default"
  description = "Resource group name."
}

variable "app_serviceplan_name" {
  default     = "asp-simple-default-02"
  description = "App Service Plan name." 
}

variable "linux_web_app_name" {
  default     = "app-simple-app-default-02"
  description = "Linux Web App name."   
}

variable "key_vault_name" {
  default     = "kv-rickylab-default-02"
  description = "Key Vault name"   
}

variable "secret_name" {
  default     = "secret-rickylab-default-02"
  description = "Secret name"       
}

variable "asp_sku_name" {
  description = "App Service Plan SKU"       
}
