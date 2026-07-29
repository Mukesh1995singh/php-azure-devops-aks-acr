@description('The Azure region where the container registry will be deployed.')
param location string = resourceGroup().location

@description('Azure Container Registry name. Must be globally unique, alphanumeric only, 5-50 characters.')
@minLength(5)
@maxLength(50)
param acrName string

@description('ACR SKU')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param acrSku string = 'Standard'

@description('Enable or disable admin user credentials for the registry.')
param adminUserEnabled bool = false

@description('Allow or deny public network access to the container registry.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Tags to apply to the resources.')
param tags object = {
  Environment: 'Production'
  Project: 'AKS-CICD'
}

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: acrName
  location: location
  tags: tags
  sku: {
    name: acrSku
  }
  properties: {
    // Recommended: keep disabled and use Managed Identity
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: publicNetworkAccess
  }
}

@description('The resource ID of the container registry.')
output acrId string = acr.id

@description('The login server URL for the container registry.')
output acrLoginServer string = acr.properties.loginServer

@description('The name of the created ACR instance.')
output acrName string = acr.name

@description('The SKU of the created ACR instance.')
output acrSku string = acr.sku.name
