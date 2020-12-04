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

Now that the cloud infrastructure is set up, it's time to configure the Azure File Shares for Octopus Deploy to have a place to store persistent data that isn't on the database. To do this, you'll create a few Azure File Shares via Azure CLI, a Kubernetes secret so K8s can authenticate to Azure, and mount the volumes.

7. Run the `storage.ps1` PowerShell script under Kubernetes Manifest --> Persistent-Storage. It connents to the storage account you created in Terraform and creates the File Shares that you need to mount for persistent storage, along with echos out the storage account name and connection key for step 8
8. Create a Database Master Secret for Octopus Deploy to have the ability to run mulitple replicas: `openssl rand 16 | base64`
9. Create a Kubernetes secret by running the following (note: the storage account name and storage account secret are what you receive from the `storage.ps1` output):
`kubectl create secret generic azure-secret --from-literal=azurestorageaccountname=storage_account_name --from-literal=azurestorageaccountkey=storage_account_key`
10. Deploy the Kubernetes manifest that's found in Kubernetes-Manifest --> Application to the AKS cluster