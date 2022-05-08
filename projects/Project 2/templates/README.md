# Hub-Spoke Network Topology & Shared Services

You can use ARM, Bicep, or Terraform to build the network starting point for Hub Spoke topology.

## Deploy via Azure CLI

### 1. Create a Resource Group

```
az group create \
  --name hub-spoke-demo \
  --location westus2
```

### 2. Deploy via ARM (option 1)

```
az deployment group create \
  --name deployment-001 \
  --resource-group hub-spoke-demo \
  --template-file azuredeploy.json
```

### 3. Deploy via Bicep (option 2)

```
az deployment group create \
  --name bicep-deployment-001 \
  --resource-group hub-spoke-demo \
  --template-file azuredeploy.bicep
```

### 4. Deploy via Terraform (option 3)

Coming soon...

## Go Back
[Back to Project 2](https://github.com/mikepfeiffer/azure-network-101/tree/main/projects/Project%202)