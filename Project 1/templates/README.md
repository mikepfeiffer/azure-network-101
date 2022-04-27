# Single VNET Design & Segmentation

Here's how to use this template to build your VNET + WEB & SQL Servers.

## Create a Resource Group

```
az group create \
  --name wordpress-rg \
  --location westus2
```

## Deploy the Template

```
az deployment group create \
  --name deployment-001 \
  --resource-group wordpress-rg \
  --template-file azuredeploy.json
```
