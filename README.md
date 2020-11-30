# Azure-AKS-OctopusDeploy

This repository contains a code base that you can use to create an AKS cluster and run Octopus Deploy as a deployment in AKS.

## Prerequisites
To use this code base, you will need the following:
1. Terraform installed
2. Azure CLI installed and configured
3. Kubectl installed

## Directions
1. Create an Azure Service Principal (app registration) that will have access for creating the AKS cluster. You can do so by running the script in Service-Principal directory.
2. Create a Key Vault that will store the app registration (created in step 2) Client ID and Client Secret. You can create the Key Vault with the Terraform configuration found in the Keyvault-Terraform directory.
3. Create a Storage Account that stores the Terraform State configuration. You can create the Storage Account with the Terraform configuration found in the Storage-Account-Terraform directory.
4. Create an AKS cluster. You can create the AKS cluster with the Terraform configuration found in the AKS-Terraform directory.
5. Create a SQL Server and SQL DB. You can create the database configurations with the Terraform configuration found in the SQL-Terraform directory.
6. Log into the AKS cluster locally by running the following command:
```
az aks get-credentials --name aks_cluster_name --resource-group resource_group_name_where_the_AKS_cluster_exists
```
7. Deploy the Kubernetes manifest that's found in the Kubernetes-Manifest directory to the AKS cluster