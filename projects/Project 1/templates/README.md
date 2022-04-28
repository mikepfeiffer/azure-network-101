# Single VNET Design & Segmentation

Here's how to use the [template](https://github.com/mikepfeiffer/azure-network-101/blob/main/projects/Project%201/templates/azuredeploy.json) to build the network starting point for your VNET + WEB & SQL Servers.

## Deploy via Azure CLI

### 1. Create a Resource Group

```
az group create \
  --name wordpress-rg \
  --location westus2
```

### 2. Deploy the Template

```
az deployment group create \
  --name deployment-001 \
  --resource-group wordpress-rg \
  --template-file azuredeploy.json
```

### 3. Deploy as a Bicep code

```
az deployment group create \
  --name bicep-deployment-001 \
  --resource-group wordpress-rg \
  --template-file azuredeploy.bicep
```
