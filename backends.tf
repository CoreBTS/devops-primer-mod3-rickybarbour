terraform { 
  backend "azurerm" {
    resource_group_name  = "rg-devopsprimer-shared-01"
    storage_account_name = "sttfdevopsprimer01"
    container_name       = "tfstate-devops-primer-mod3-rickybarbour"
    key                  = "terraform.tfstate"
  }
}
