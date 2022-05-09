# Creates the Hub Virtual network
resource "azurerm_virtual_network" "Hub-Network" {
  name                = "hub-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = [var.Vnetaddresses["Hub Vnet"]]
}

# Creates the shared services subnet in the hub network

resource "azurerm_subnet" "shared-subnet" {
  name                 =  var.Subnets["Shared Subnet"]
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = [var.Subnet-address["Shared Subnet"]]
}

# Creates the Bastion subnet inside of the hub network

resource "azurerm_subnet" "Azure-Bastion" {
  name                 =  var.Subnets["Azure Bastion Subnet"]
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = [var.Subnet-address ["Azure Bastion Subnet"]]
}

# Creates the Azure firewall subnet inside of the hub network

resource "azurerm_subnet" "Azure-Firewall" {
  name                 =  var.Subnets["Azure Firewall Subnet"]
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.Hub-Network.name
  address_prefixes     = [var.Subnet-address["Azure Firewall Subnet"]]
}

# Creates the Spoke 1 Virtual network
resource "azurerm_virtual_network" "spoke-1" {
  name                = "spoke1-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = [var.Vnetaddresses["Spoke 1"]]
}

# Creates the Development workload subnet in the Spoke 1 network
resource "azurerm_subnet" "Development-network" {
  name                 = var.Subnets["Workload Subnet"]
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.spoke-1.name
  address_prefixes     = [var.Subnet-address["Spoke 1 Subnet"]]
}

# Creates the Spoke 2 Virtual network
resource "azurerm_virtual_network" "spoke-2" {
  name                = "spoke2-vnet"
  resource_group_name = azurerm_resource_group.Main-RG.name
  location            = azurerm_resource_group.Main-RG.location
  address_space       = [var.Vnetaddresses["Spoke 2"]]
}

# Creates the Production workload subnet in the Spoke 2 network
resource "azurerm_subnet" "Production-network" {
  name                 =  "Workloadsubnet"
  resource_group_name  = azurerm_resource_group.Main-RG.name
  virtual_network_name = azurerm_virtual_network.spoke-2.name
  address_prefixes     = [var.Subnet-address["Spoke 2 Subnet"]]
}