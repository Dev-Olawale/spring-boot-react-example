#!/bin/bash

# Variables
resource_group_name="rg-springboot-react-backend"
location="westeurope"
storage_account_name="stjavatfstate"
container_name="java"

# Create the Resource Group
az group create --name $resource_group_name --location $location

# Create the Storage Account
az storage account create \
  --name $storage_account_name \
  --resource-group $resource_group_name \
  --location $location \
  --sku Standard_LRS \
  --kind StorageV2

# Get the Storage Account Key
storage_account_key=$(az storage account keys list \
  --resource-group $resource_group_name \
  --account-name $storage_account_name \
  --query [0].value -o tsv)

# Create the Storage Container
az storage container create \
  --name $container_name \
  --account-name $storage_account_name \
  --account-key $storage_account_key

echo "Resource Group: $resource_group_name, Storage Account: $storage_account_name, Container: $container_name created successfully."
