targetScope = 'resourceGroup'

// =======================================================
// PARAMETERS
// =======================================================

@description('Azure deployment region')
param location string = resourceGroup().location


@description('Environment name')
param environment string = 'dev'


@description('Common resource tags')
param tags object = {
  Environment: environment
  Project: 'PHP-AZURE-DEVOPS-AKS'
  ManagedBy: 'Bicep'
}


// =======================================================
// RESOURCE NAMES
// =======================================================

@description('Azure Container Registry name')
param acrName string


@description('AKS cluster name')
param aksName string


@description('Azure Key Vault name')
param keyVaultName string


@description('MySQL Flexible Server name')
param mysqlServerName string



// =======================================================
// MYSQL PARAMETERS
// =======================================================

@description('MySQL administrator username')
param mysqlAdminUsername string = 'mysqladmin'


@secure()
@description('MySQL administrator password')
param mysqlAdminPassword string


@description('Application database name')
param databaseName string = 'phpappdb'


@description('MySQL network mode')
@allowed([
  'Enabled'
  'Disabled'
])
param mysqlPublicNetworkAccess string = 'Disabled'


param mysqlDelegatedSubnetResourceId string = ''

param mysqlPrivateDnsZoneResourceId string = ''



// =======================================================
// AKS WORKLOAD IDENTITY PARAMETERS
// =======================================================

param k8sNamespace string = 'php-app'

param k8sServiceAccountName string = 'php-app-sa'



// =======================================================
// 1. LOG ANALYTICS WORKSPACE
// =======================================================

module logAnalytics './modules/loganalytics.bicep' = {

  name: 'logAnalyticsDeployment'

  params: {

    location: location

    workspaceName: '${aksName}-law'

    tags: tags
  }
}



// =======================================================
// 2. AZURE CONTAINER REGISTRY
// =======================================================

module acr './modules/acr.bicep' = {

  name: 'acrDeployment'

  params: {

    location: location

    acrName: acrName

    acrSku: 'Standard'

    tags: tags
  }
}



// =======================================================
// 3. KEY VAULT
// =======================================================

module keyvault './modules/keyvault.bicep' = {

  name: 'keyVaultDeployment'

  params: {

    location: location

    keyVaultName: keyVaultName

    enablePurgeProtection: true

    softDeleteRetentionInDays: 90

    tags: tags
  }
}



// =======================================================
// 4. AKS CLUSTER
// =======================================================

module aks './modules/aks.bicep' = {

  name: 'aksDeployment'

  params: {

    location: location

    aksName: aksName

    kubernetesVersion: '1.30.9'

    nodeVmSize: 'Standard_D2s_v5'

    nodeCount: 2

    enablePrivateCluster: false

    enableAzureRBAC: true

    logAnalyticsWorkspaceId: logAnalytics.outputs.workspaceId

    tags: tags

  }

}



// =======================================================
// 5. MYSQL FLEXIBLE SERVER
// =======================================================

module mysql './modules/mysql.bicep' = {

  name: 'mysqlDeployment'

  params: {

    location: location

    mysqlServerName: mysqlServerName


    databaseName: databaseName


    administratorLogin: mysqlAdminUsername


    administratorLoginPassword: mysqlAdminPassword


    skuTier: 'GeneralPurpose'


    skuName: 'Standard_D2ds_v4'


    highAvailabilityMode: environment == 'prod'
      ? 'ZoneRedundant'
      : 'Disabled'


    storageSizeGB: 32


    backupRetentionDays: environment == 'prod'
      ? 35
      : 7


    geoRedundantBackup: environment == 'prod'
      ? 'Enabled'
      : 'Disabled'


    publicNetworkAccess: mysqlPublicNetworkAccess


    delegatedSubnetResourceId: mysqlDelegatedSubnetResourceId


    privateDnsZoneArmResourceId: mysqlPrivateDnsZoneResourceId


    tags: tags
  }

}



// =======================================================
// 6. APPLICATION MANAGED IDENTITY
// Used by AKS Workload Identity
// =======================================================

resource phpAppIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {

  name: '${aksName}-php-app-mi'

  location: location

  tags: tags

}



// =======================================================
// 7. FEDERATED IDENTITY CREDENTIAL
// Kubernetes ServiceAccount --> Managed Identity
// =======================================================

resource federatedCredential 'Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2023-01-31' = {


  name: 'php-app-federated-identity'


  parent: phpAppIdentity


  properties: {

    issuer: aks.outputs.oidcIssuerUrl


    subject: 'system:serviceaccount:${k8sNamespace}:${k8sServiceAccountName}'


    audiences: [

      'api://AzureADTokenExchange'

    ]

  }

}



// =======================================================
// 8. AKS KUBELET --> ACR PULL
// =======================================================

var acrPullRoleId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '7f951dda-4ed3-4680-a7ca-43fe172d538d'
)



resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {


  name: guid(
    acr.outputs.acrId,
    aks.outputs.kubeletObjectId,
    acrPullRoleId
  )


  scope: acr


  dependsOn: [

    acr

    aks

  ]


  properties: {


    roleDefinitionId: acrPullRoleId


    principalId: aks.outputs.kubeletObjectId


    principalType: 'ServicePrincipal'

  }

}



// =======================================================
// 9. WORKLOAD IDENTITY --> KEY VAULT SECRET USER
// =======================================================


resource keyVaultSecretUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {


  name: guid(

    keyvault.outputs.keyVaultId,

    phpAppIdentity.properties.principalId,

    'KeyVaultSecretsUser'

  )


  scope: keyvault


  dependsOn: [

    keyvault

    phpAppIdentity

  ]


  properties: {


    roleDefinitionId: keyvault.outputs.secretsUserRoleId


    principalId: phpAppIdentity.properties.principalId


    principalType: 'ServicePrincipal'

  }

}



// =======================================================
// OUTPUTS
// =======================================================


output acrLoginServer string = acr.outputs.acrLoginServer


output aksClusterName string = aks.outputs.aksName


output keyVaultUri string = keyvault.outputs.keyVaultUri


output mysqlFqdn string = mysql.outputs.mysqlFqdn


output databaseName string = mysql.outputs.databaseName


output phpManagedIdentityClientId string = phpAppIdentity.properties.clientId


output phpManagedIdentityPrincipalId string = phpAppIdentity.properties.principalId


output oidcIssuerUrl string = aks.outputs.oidcIssuerUrl


output logAnalyticsWorkspaceId string = logAnalytics.outputs.workspaceId
