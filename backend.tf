terraform {
  backend "azurerm" {
    resource_group_name  = "cohort3-rg-immersion-dev"
    storage_account_name = "capstone4321"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# terraform {
#   backend "local" {
#     path = "tfstate/terraform.tfstate"
#   }
# }