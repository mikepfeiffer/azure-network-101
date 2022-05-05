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

Coming soon...

### 4. Deploy via Terraform (option 3)

Coming soon...