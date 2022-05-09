variable "primary_location" {
  type = string
  description = "Primary Location"
  default = "WestUS2"
}

variable "Admin-Username" {
  type = string
  description = "Admin-Username"
  default = "sysadmin"
}

variable "Admin-Password" {
  type = string
  description = "Admin-Password"
  default = "P@ssw0rd2020"
}

variable "Vnetaddresses" {
  type = map(string)
  default = {
    "Hub Vnet"              = "192.168.0.0/16"
    "Spoke 1"               = "10.10.0.0/16"
    "Spoke 2"               = "10.100.0.0/16"
  }
}

variable "Subnets" {
  type = map(string)
  default = {
    "Azure Firewall Subnet" = "AzureFirewallSubnet"
    "Azure Bastion Subnet"  = "AzureBastionSubnet"
    "Shared Subnet"         = "SharedSubnet"
    "Workload Subnet"       = "WorkloadSubnet"
  }
}

variable "Subnet-address" {
  type = map(string)
  default = {
    "Azure Firewall Subnet" = "192.168.0.0/26"
    "Azure Bastion Subnet"  = "192.168.1.0/26"
    "Shared Subnet"         = "192.168.2.0/24"
    "Spoke 1 Subnet"        = "10.10.1.0/24"
    "Spoke 2 Subnet"        = "10.100.1.0/24"
  }
}

