var hubVnetPrefix = '192.168.0.0/16'
var dmzSubnetName = 'AzureFirewallSubnet'
var dmzSubnetPrefix = '192.168.0.0/26'
var mgmtSubnetName = 'AzureBastionSubnet'
var mgmtSubnetPrefix = '192.168.1.0/26'
var sharedSubnetName = 'SharedSubnet'
var sharedSubnetPrefix = '192.168.2.0/24'
var Spoke1VnetName_var = 'spoke1-vnet'
var Spoke1VnetPrefix = '10.10.0.0/16'
var Spoke2VnetName_var = 'spoke2-vnet'
var Spoke2VnetPrefix = '10.100.0.0/16'
var spokeWorkloadSubnetName = 'WorkloadSubnet'
var Spoke1WorkloadSubnetPrefix = '10.10.1.0/24'
var Spoke2WorkloadSubnetPrefix = '10.100.1.0/24'
var location = resourceGroup().location

resource hub_vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'hub-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubVnetPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource hub_vnet_mgmtSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  parent: hub_vnet
  name: mgmtSubnetName
  properties: {
    addressPrefix: mgmtSubnetPrefix
  }
}

resource hub_vnet_sharedSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  parent: hub_vnet
  name: sharedSubnetName
  properties: {
    addressPrefix: sharedSubnetPrefix
  }
  dependsOn: [
    hub_vnet_mgmtSubnetName
  ]
}

resource hub_vnet_dmzSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  parent: hub_vnet
  name: dmzSubnetName
  properties: {
    addressPrefix: dmzSubnetPrefix
  }
  dependsOn: [
    hub_vnet_mgmtSubnetName
    hub_vnet_sharedSubnetName
  ]
}

resource Spoke1VnetName 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: Spoke1VnetName_var
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        Spoke1VnetPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource Spoke1VnetName_spokeWorkloadSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  parent: Spoke1VnetName
  name: '${spokeWorkloadSubnetName}'
  properties: {
    addressPrefix: Spoke1WorkloadSubnetPrefix
  }
}

resource Spoke2VnetName 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: Spoke2VnetName_var
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        Spoke2VnetPrefix
      ]
    }
    enableDdosProtection: false
    enableVmProtection: false
  }
}

resource Spoke2VnetName_spokeWorkloadSubnetName 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  parent: Spoke2VnetName
  name: '${spokeWorkloadSubnetName}'
  properties: {
    addressPrefix: Spoke2WorkloadSubnetPrefix
  }
}
