provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      purge_soft_deleted_keys_on_destroy = true
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_key_vaults = true
      recover_soft_deleted_secrets = true
    }       
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.25.0"
    }
  }    
  backend "azurerm" {
    resource_group_name  = "rg-devopsprimer-shared-01"
    storage_account_name = "sttfdevopsprimer01"
    container_name       = "tfstate-devops-primer-mod3-rickybarbour"
    key                  = "terraform.tfstate"
  }
}
