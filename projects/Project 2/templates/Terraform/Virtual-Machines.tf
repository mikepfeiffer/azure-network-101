#Creates Web Virtual Machine/OS Disk
resource "azurerm_virtual_machine" "Web" {
  name                  = "${var.Web-Prefix}-vm"
  location              = azurerm_resource_group.Main-RG.location
  resource_group_name   = azurerm_resource_group.Main-RG.name
  network_interface_ids = [azurerm_network_interface.Web-Nic.id]
  vm_size               = "Standard_DS1_v2"

 storage_image_reference {
    publisher = "Microsoft"
    offer     = "MicrosoftWindowsServer"
    sku       = "2022-datacenter"
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
    subnet_id                     = azurerm_subnet.shared-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}