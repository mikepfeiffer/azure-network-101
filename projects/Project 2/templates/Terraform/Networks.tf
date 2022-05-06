# Creates the Hub Virtual network
resource "azurerm_virtual_network" "Hub-Network" {
  name                = "hub-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = ["192.168.0.0/16"]
}

# Creates the shared services subnet in the hub network

resource "azurerm_subnet" "shared-subnet" {
  name                 =  "sharedsubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = ["192.168.2.0/24"]
}

# Creates the Bastion subnet inside of the hub network

resource "azurerm_subnet" "Azure-Bastion" {
  name                 =  "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = ["192.168.1.0/26"]
}

# Creates the Azure firewall subnet inside of the hub network

resource "azurerm_subnet" "Azure-Firewall" {
  name                 =  "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = ["192.168.0.0/26"]
}

# Creates the Spoke 1 Virtual network
resource "azurerm_virtual_network" "Spoke-1" {
  name                = "spoke1-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = ["10.10.0.0/16"]
}

# Creates the Development workload subnet in the Spoke 1 network
resource "azurerm_subnet" "Development-network" {
  name                 =  "Workloadsubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Spoke-1.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Creates the Spoke 2 Virtual network
resource "azurerm_virtual_network" "Spoke-2" {
  name                = "spoke2-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = ["10.100.0.0/16"]
}

# Creates the Production workload subnet in the Spoke 1 network
resource "azurerm_subnet" "Production-Network" {
  name                 =  "Workloadsubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Spoke-1.name
  address_prefixes     = ["10.100.1.0/24"]
}