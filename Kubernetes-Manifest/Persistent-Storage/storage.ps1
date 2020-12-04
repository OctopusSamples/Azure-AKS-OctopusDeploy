# The configuration below creates a storage account for Kubernetes persistent storage.
# The perisistent storage is used for data in Octopus Deploy that isn't stored in a DB

$AKS_PERS_STORAGE_ACCOUNT_NAME = ""
$AKS_PERS_RESOURCE_GROUP = ""
$AKS_PERS_SHARE_NAME = @(
    "tasklogs",
    "artifacts",
    "repository"
)

$connectionString = $(az storage account show-connection-string -n $AKS_PERS_STORAGE_ACCOUNT_NAME -g $AKS_PERS_RESOURCE_GROUP -o tsv)

foreach ($share in $AKS_PERS_SHARE_NAME) {
    az storage share create --name $share --connection-string $connectionString
}

# Get storage account key
$STORAGE_KEY = $(az storage account keys list --resource-group $AKS_PERS_RESOURCE_GROUP --account-name $AKS_PERS_STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv)

# Echo storage account name and key
echo $AKS_PERS_STORAGE_ACCOUNT_NAME
echo $STORAGE_KEY