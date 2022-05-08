# Hub-Spoke Network Topology & Shared Services

In this project you'll build a simple hub and spoke network topology in Azure.

![Project 2 Hub-Spoke Network Topology & Shared Services](https://user-images.githubusercontent.com/5126491/166937555-d9b727fc-f9b4-4943-99a5-07d4d5a060ec.jpg)

## 1. Create the Hub-Spoke Network Topology

Create the Hub Spoke VNet architecture using the IaC code in the [/templates](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%202/templates) folder of this repo.

## 2. Deploy Windows Server VMs

Next, you'll need to deploy servers into the Hub and Spoke 1 and Spoke 2 VNets:

* Deploy a Windows Server into the **Hub** VNet in the **SharedSubnet**
* Deploy a Windows Server into the **Spoke 1** VNet in the **WorkloadSubnet**
* Deploy a Windows Server into the **Spoke 2** VNet in the **WorkloadSubnet**

*Note: I used Standard_D2s_v3 with Windows Server 2022 Datacenter Edition for each of this and that worked well.*

## 3. Configure Your DNS Server

Let's setup a "shared service" in the "hub" VNet.

1. Connect remotely to the DNS server in your Hub VNet via RDP. Install the DNS server service.

2. Add a forward lookup zone for a domain (e.g. contoso.local)

3. Add host (A) records for both of servers in each of the spoke virtual networks (e.g. web1, web2)

4. DNS is our "shared service" in this example. Our goal is to be able to resolve internal DNS names from nodes in the spoke networks by querying the shared DNS service in the Hub network.

*Note: I'm not going to take the time to domain join or workgroup any machines in this lab, so you'll need to consider the local Windows Firewall when you're trying to make things work.*

## 4. Configure DNS on Your Spoke Networks

* You'll want to make sure new VMs and services deployed to your spoke networks know exactly where to go when accessing the "shared" DNS service.

* Configure each spoke VNET and make sure it's handing out your *custom* DNS server address for your shared service. Make sure to double check the IP address to ensure you use the correct one.

## 5. Use Azure Network Manager to Create a Hub-Spoke Topology

We're going to use the new [Azure Network Manager](https://docs.microsoft.com/en-us/azure/virtual-network-manager/create-virtual-network-manager-portal) service to manage connectivity for all our virtual networks.

*Important note: at the time of writing this guide the Azure Network Manager service is in preview. You'll need to [manually register the provider](https://docs.microsoft.com/en-us/azure/virtual-network-manager/create-virtual-network-manager-portal#register-subscription-for-public-preview)*

1. Create Virtual Network Manager
2. Create a network group
3. Create a connectivity configuration (leave *Direct Connectivity* disabled)
4. Deploy the connectivity configuration

Make sure you watch my demo (coming soon) and review this [doc](https://docs.microsoft.com/en-us/azure/virtual-network-manager/create-virtual-network-manager-portal) for clarity on the steps until I can add more detail here.

## 6. Validate Shared Service Access

At this point you should have connectivity to the hub VNet from each spoke network. Now let's validate the configuration.

1. Connect to the server in the spoke 1 network and make sure the primary DNS server address is set to the "shared" DNS server IP from the "hub" VNet. Use tools like *ping* and *nslookup* to make sure the nodes in spoke 1 can resolve names from the DNS server.

2. Do the same thing for spoke 2. Connect to the server in the spoke 2 network and make sure the primary DNS server address is set to the "shared" DNS server IP from the "hub" VNet. 

*NOTE: Use tools like *ping* and *nslookup* to make sure the nodes in spoke 1 can resolve names from the DNS server.*

## 8. Set up Direct Connectivity

Try implementing a new connectivity configuration with Azure Network Manager.

* Remove and redeploy a new configuration that supports **Direct Connectivity**

Can you ping the server in spoke 2 from the server in spoke 1 and vice versa? If so, what other ways can you restrict the traffic coming across those VNets? *(hint: we covered it in [project #1](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%201))*

Remember, you'll need to consider the local Windows Firewall when you're trying to make things work.

## 9. Setup Remote Access

Add a new subnet to your VNET so we can deploy Azure Bastion for remote access.

| Subnet Name        | CIDR            |
| -----------        | -----------     |
| AzureBastionSubnet | 192.168.1.0/26  |

Deploy a new Bastion to this subnet and verify that you can still SSH to your servers through it.

## 10. Challenge: Isolate Your Spoke VNets

Take what you've learned from both project #1 and project #2 and implement another layer of isolation. How can you use NSGs/ASGs on the spoke VNets to futher isolate those networks? What scenario's could you test within these environments to reinforce what you've learned?

## Recommended Reading


* [Hub-spoke network topology in Azure](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?tabs=cli)
* [Create a secured hub and spoke network](https://docs.microsoft.com/en-us/azure/virtual-network-manager/tutorial-create-secured-hub-and-spoke)
* [Azure Virtual Network Manager](https://docs.microsoft.com/en-us/azure/virtual-network-manager/create-virtual-network-manager-portal)
* [Hub-spoke with Azure Firewall Manager](https://docs.microsoft.com/en-us/azure/firewall-manager/secure-hybrid-network)

## Course Index
[mikepfeiffer/azure-network-101](https://github.com/mikepfeiffer/azure-network-101)