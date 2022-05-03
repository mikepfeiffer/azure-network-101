# Single VNET Design & Segmentation

You can use ARM, Bicpe, or Terraform to build the network starting point for your VNET + WEB & SQL Servers.

## Deploy via Azure CLI

### 1. Create a Resource Group

```
az group create \
  --name wordpress-rg \
  --location westus2
```

### 2. Deploy the ARM Template (option 1)

```
az deployment group create \
  --name deployment-001 \
  --resource-group wordpress-rg \
  --template-file azuredeploy.json
```

### 3. Deploy the Bicep Template (option 2)

```
az deployment group create \
  --name bicep-deployment-001 \
  --resource-group wordpress-rg \
  --template-file azuredeploy.bicep
```

### 4. Deploy via Terramform

Follow [these instructions](https://github.com/mikepfeiffer/azure-network-101/blob/main/projects/Project%201/templates/Terraform/README.md) if you'd like to deploy the VNet via Terraform.