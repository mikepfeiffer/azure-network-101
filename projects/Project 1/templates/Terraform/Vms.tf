
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

#Creates Web Virtual Machine/OS Disk
resource "azurerm_virtual_machine" "Web" {
  name                  = "${var.Web-Prefix}-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.Web-Nic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "WEB-OS-DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
 os_profile {
    computer_name  = "${var.Web-Prefix}"
    admin_username = "${var.Admin-Username}"
    admin_password = "${var.Admin-Password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Creates Network Interface Card for Web VM
resource "azurerm_network_interface" "Web-Nic" {
  name                = "Web-Nic"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location

  ip_configuration {
    name                          = "Web-IP"
    subnet_id                     = azurerm_subnet.web-vnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Web-public-ip.id
  }
}

# Creates Public IP for Web NIC
resource "azurerm_public_ip" "Web-public-ip" {
  name                = "Web-Public-IP"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  allocation_method   = "Dynamic"
}

# Creates SQL Virtual Machine/OS Disk
resource "azurerm_virtual_machine" "Sql" {
  name                  = "${var.Sql-Prefix}-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.Sql-Nic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = "SQL-OS-DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
 os_profile {
    computer_name  = "${var.Sql-Prefix}"
    admin_username = "${var.Admin-Username}"
    admin_password = "${var.Admin-Password}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

  # Creates Network Interface Card for SQL VM
resource "azurerm_network_interface" "Sql-Nic" {
  name                = "Sql-Nic"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location

  ip_configuration {
    name                          = "Sql-IP"
    subnet_id                     = azurerm_subnet.sql-vnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Sql-public-ip.id
    }
  }
# Creates Public IP for SQL NIC
resource "azurerm_public_ip" "Sql-public-ip" {
  name                = "Sql-Public-IP"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  allocation_method   = "Dynamic"
}
