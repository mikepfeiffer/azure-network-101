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