terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.25.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

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

provider "random" {}
