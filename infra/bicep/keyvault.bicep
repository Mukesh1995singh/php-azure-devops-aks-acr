@description('Azure region where Key Vault will be deployed')
param location string = resourceGroup().location

@description('Azure Key Vault name. Must be globally unique, 3-24 alphanumeric characters or hyphens.')
@minLength(3)
@maxLength(24)
param keyVaultName string

@description('Enable purge protection to prevent accidental permanent deletion.')
param enablePurgeProtection bool = true

@description('Retention period in days for soft-deleted vault and items.')
@minValue(7)
@maxValue(90)
param softDeleteRetentionInDays int = 90

@description('Network ACL rules for Key Vault restricting public access or integrating Private Endpoints.')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
  ipRules: []
  virtualNetworkRules: []
}

@description('Tags applied to Key Vault')
param tags object = {}

// Azure Key Vault Resource
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags

  properties: {
    // Azure RBAC authorization model
    enableRbacAuthorization: true

    // Soft Delete & Purge Protection
    enableSoftDelete: true
    softDeleteRetentionInDays: softDeleteRetentionInDays
    enablePurgeProtection: enablePurgeProtection

    tenantId: subscription().tenantId

    sku: {
      name: 'standard'
      family: 'A'
    }

    // Public access toggle & Network ACL rules
    publicNetworkAccess: 'Enabled'
    networkAcls: networkAcls
  }
}

// Built-in Role ID for "Key Vault Secrets User"
var keyVaultSecretsUserRoleId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')

// Outputs
@description('Key Vault Resource ID')
output keyVaultId string = keyVault.id

@description('Key Vault Name')
output keyVaultName string = keyVault.name

@description('Key Vault URI for SecretProviderClass configuration')
output keyVaultUri string = keyVault.properties.vaultUri

@description('Key Vault Secrets User Built-in Role ID for RBAC Role Assignment')
output secretsUserRoleId string = keyVaultSecretsUserRoleId
