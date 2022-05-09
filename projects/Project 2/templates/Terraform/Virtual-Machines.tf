#Creates Hub Virtual Machine
resource "azurerm_virtual_machine" "hub-VM" {
  name                  = "Hub-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.Hub-VMnic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  storage_os_disk {
    name              = "HUB-VM-DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
 os_profile {
    computer_name  = "Hub-vm"
    admin_username = "${var.Admin-Username}"
    admin_password = "${var.Admin-Password}"
  }

   os_profile_windows_config {
  }
}

# Creates Network Interface Card for Hub VM
resource "azurerm_network_interface" "Hub-VMnic" {
  name                = "HubVM-Nic"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location

  ip_configuration {
    name                          = "Hub-VM-IP"
    subnet_id                     = azurerm_subnet.shared-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creates Spoke 1 Virtual Machine
resource "azurerm_virtual_machine" "spoke1-VM" {
  name                  = "Spoke1-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.spoke1-nic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Spoke1-VM-DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
 os_profile {
    computer_name  = "Spoke1-vm"
    admin_username = "${var.Admin-Username}"
    admin_password = "${var.Admin-Password}"
  }

   os_profile_windows_config {
  }
}

# Creates Network Interface Card for spoke 1 VM
resource "azurerm_network_interface" "spoke1-nic" {
  name                = "spoke1VM-Nic"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location

  ip_configuration {
    name                          = "Spoke1-VM-IP"
    subnet_id                     = azurerm_subnet.Development-network.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Creates Spoke 2 Virtual Machine
resource "azurerm_virtual_machine" "spoke2-VM" {
  name                  = "Spoke2-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.spoke2-nic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  storage_os_disk {
    name              = "Spoke2-VM-DISK"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }
 os_profile {
    computer_name  = "Spoke2-vm"
    admin_username = "${var.Admin-Username}"
    admin_password = "${var.Admin-Password}"
  }

   os_profile_windows_config {
  }
}

# Creates Network Interface Card for spoke 2 VM
resource "azurerm_network_interface" "spoke2-nic" {
  name                = "spoke2VM-Nic"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location

  ip_configuration {
    name                          = "Spoke2-VM-IP"
    subnet_id                     = azurerm_subnet.Production-network.id
    private_ip_address_allocation = "Dynamic"
  }
}