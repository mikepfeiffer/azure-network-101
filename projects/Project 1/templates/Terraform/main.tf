
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

# Create a resource group
resource "azurerm_resource_group" "Main-RG" {
  name     = "Wordpress-rg"
  location = var.primary_location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "Main-Network" {
  name                = "wp-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = ["192.168.0.0/16"]
}

# Create a Subnet within the Virtual Network address space
resource "azurerm_subnet" "web-vnet" {
  name                 =  "Web"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Main-Network.name
  address_prefixes     = ["192.168.1.0/24"]
  enforce_private_link_endpoint_network_policies  = "true"
  enforce_private_link_service_network_policies   = "true"
}

# Create a Subnet within the Virtual Network address space
resource "azurerm_subnet" "sql-vnet" {
  name                 = "Sql"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Main-Network.name
  address_prefixes     = ["192.168.2.0/24"]
  enforce_private_link_endpoint_network_policies  = "true"
  enforce_private_link_service_network_policies   = "true"
}

# Create a Network Security Group to allow SSH
resource "azurerm_network_security_group" "Web-nsg" {
  name                = "web-nsg"
  location            = azurerm_resource_group.Main-RG.location
  resource_group_name = azurerm_resource_group.Main-RG.name

  security_rule {
    name                       = "SSH"
    priority                   = "300"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create a Network Security Group to allow SSH
resource "azurerm_network_security_group" "sql-nsg" {
  name                = "sql-nsg"
  location            = azurerm_resource_group.Main-RG.location
  resource_group_name = azurerm_resource_group.Main-RG.name

  security_rule {
    name                       = "SSH"
    priority                   = "300"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the Web NSG with the Web Subnet
resource "azurerm_subnet_network_security_group_association" "web-association" {
  subnet_id                 = azurerm_subnet.web-vnet.id
  network_security_group_id = azurerm_network_security_group.Web-nsg.id
}

# Associate the SQL NSG with the SQl Subnet
resource "azurerm_subnet_network_security_group_association" "sql-association" {
  subnet_id                 = azurerm_subnet.sql-vnet.id
  network_security_group_id = azurerm_network_security_group.sql-nsg.id
}


