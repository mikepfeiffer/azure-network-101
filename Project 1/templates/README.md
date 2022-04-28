# Single VNET Design & Segmentation

Here's how to use the [template](https://github.com/mikepfeiffer/azure-network-101/blob/main/Project%201/templates/azuredeploy.json) to build the network starting point for your VNET + WEB & SQL Servers.

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

## Deploy via Azure Portal

Click the button below to deploy the template.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fmikepfeiffer%2Fazure-domain-controller%2Fmaster%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

<br>
⏪ [Project: Single VNET Design & Segmentation](https://github.com/mikepfeiffer/azure-network-101/tree/main/Project%201)