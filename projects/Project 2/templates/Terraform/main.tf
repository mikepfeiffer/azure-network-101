
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Creates the Hub Spoke Demo resource group
resource "azurerm_resource_group" "Main-RG" {
  name     = "hub-spoke-demo"
  location = var.primary_location
}