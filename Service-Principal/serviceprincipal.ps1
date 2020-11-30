function newAppRegistration {
    
    param(
        [string]$name = "od-aks"
    )
    
    # Create App Registration
    $appCreation = az ad sp create-for-rbac --skip-assignment --name $name --sdk-auth | ConvertFrom-Json
    $appCreation
}