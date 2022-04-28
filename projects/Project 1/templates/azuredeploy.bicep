// TODO: clean-up and parameterization

param sql_server_name string = 'SQL'
param web_server_name string = 'WEB'
param admin_username string = 'sysadmin'
param azure_region string = 'westus2'

@secure()
param admin_password string = 'P@ssw0rd2020'

resource SQL_NSG 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'SQL-NSG'
  location: azure_region
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource WEB_NSG 'Microsoft.Network/networkSecurityGroups@2020-11-01' = {
  name: 'WEB-NSG'
  location: azure_region
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource SQL_IP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'SQL-IP'
  location: azure_region
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource WEB_IP 'Microsoft.Network/publicIPAddresses@2020-11-01' = {
  name: 'WEB-IP'
  location: azure_region
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource wp_vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'wp-vnet'
  location: azure_region
  properties: {
    addressSpace: {
      addressPrefixes: [
        '192.168.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'WEB'
        properties: {
          addressPrefix: '192.168.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'SQL'
        properties: {
          addressPrefix: '192.168.2.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Enabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource sql_server_name_resource 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: sql_server_name
  location: azure_region
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: 'SQL-OS-DISK'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: sql_server_name
      adminUsername: admin_username
      adminPassword: admin_password
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: SQL_NIC.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource web_server_name_resource 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: web_server_name
  location: azure_region
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_DS1_v2'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: 'WEB-OS-DISK'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: web_server_name
      adminUsername: admin_username
      adminPassword: admin_password
      linuxConfiguration: {
        disablePasswordAuthentication: false
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: WEB_NIC.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource SQL_NSG_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: SQL_NSG
  name: 'SSH'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource WEB_NSG_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2020-11-01' = {
  parent: WEB_NSG
  name: 'SSH'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource wp_vnet_SQL 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: wp_vnet
  name: 'SQL'
  properties: {
    addressPrefix: '192.168.2.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource wp_vnet_WEB 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  parent: wp_vnet
  name: 'WEB'
  properties: {
    addressPrefix: '192.168.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource SQL_NIC 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'SQL-NIC'
  location: azure_region
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '192.168.2.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: SQL_IP.id
          }
          subnet: {
            id: wp_vnet_SQL.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: SQL_NSG.id
    }
  }
}

resource WEB_NIC 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'WEB-NIC'
  location: azure_region
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '192.168.1.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: WEB_IP.id
          }
          subnet: {
            id: wp_vnet_WEB.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    networkSecurityGroup: {
      id: WEB_NSG.id
    }
  }
}
