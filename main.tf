terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  subscription_id            = "c3075d73-ddf1-45bb-a80f-f8de214a809a"
  tenant_id                  = "23db6dc4-f3d5-4c02-8017-c5fa92771002"
  client_id                  = "db51ddd4-ec4b-4870-b558-608d4edb49b9"
  client_secret              = "bh48Q~m031pu6g2OkluS6nWPOw5s6Pen2OjQyaeo"
  features {}
}
resource "azurerm_resource_group" "test" {
  name     = "MyRG"
  location = "Central India"
}
resource "azurerm_storage_account" "example" {
  name                     = "gksranamyrgsa01"
  resource_group_name      = "MyRG"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #depends_on = [ azurerm_resource_group.test ]
}
resource "azurerm_storage_container" "container01" {
  name                  = "container01"
  storage_account_name  = "gksranamyrgsa01"
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.example ]
}
resource "azurerm_storage_blob" "blob01" {
  name                   = "blob01"
  storage_account_name   = "gksranamyrgsa01"
  storage_container_name = "container01"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [ azurerm_storage_container.container01 ]
}

resource "azurerm_virtual_network" "vnet01" {
  name                = "vnet01"
  address_space       = ["10.0.0.0/16"]
  location            = "Central India"
  resource_group_name = "MyRG"
  #depends_on = [ azurerm_resource_group.test ]


  subnet {
    name                 = "subnet01"
    address_prefixes     = ["10.0.1.0/24"]
    #depends_on = [ azurerm_virtual_network.vnet01 ]
 }

  subnet {
    name                 = "subnet02"
    #resource_group_name  = MyRG
    #virtual_network_name = "vnet01"
    address_prefixes     = ["10.0.2.0/24"]
    #depends_on = [ azurerm_virtual_network.vnet01 ]
  }
}