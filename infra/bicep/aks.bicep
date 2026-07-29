// =======================================================
// AKS MODULE PARAMETERS
// =======================================================

@description('Azure region where AKS will be deployed')
param location string

@description('AKS cluster name')
param aksName string

@description('Kubernetes version')
param kubernetesVersion string = '1.30.9'

@description('System node pool VM size')
param nodeVmSize string = 'Standard_D2s_v5'

@description('System node pool node count')
param nodeCount int = 2

@description('Availability Zones for AKS nodes')
param availabilityZones array = [
  '1'
  '2'
  '3'
]

@description('Enable private AKS cluster')
param enablePrivateCluster bool = false

@description('Enable Azure RBAC for Kubernetes authorization')
param enableAzureRBAC bool = true

@description('Log Analytics Workspace Resource ID')
param logAnalyticsWorkspaceId string = ''

@description('AKS DNS Prefix')
param dnsPrefix string = '${aksName}-dns'

@description('Resource tags')
param tags object = {}

// =======================================================
// USER ASSIGNED MANAGED IDENTITY
// =======================================================

resource aksIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${aksName}-identity'
  location: location
  tags: tags
}

// =======================================================
// AKS CLUSTER
// =======================================================

resource aks 'Microsoft.ContainerService/managedClusters@2024-01-01' = {
  name: aksName
  location: location
  tags: tags

  dependsOn: [
    aksIdentity
  ]

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${aksIdentity.id}': {}
    }
  }

  properties: {
    kubernetesVersion: kubernetesVersion
    dnsPrefix: dnsPrefix
    enableRBAC: true
    enablePrivateCluster: enablePrivateCluster

    // Microsoft Entra ID + Azure RBAC
    aadProfile: {
      managed: true
      enableAzureRBAC: enableAzureRBAC
    }

    // Workload Identity OIDC
    oidcIssuerProfile: {
      enabled: true
    }

    // ===================================================
    // SYSTEM NODE POOL
    // ===================================================
    agentPoolProfiles: [
      {
        name: 'systempool'
        mode: 'System'
        type: 'VirtualMachineScaleSets'
        osType: 'Linux'
        vmSize: nodeVmSize
        count: nodeCount
        availabilityZones: availabilityZones
        enableAutoScaling: true
        minCount: 2
        maxCount: 5
        osDiskSizeGB: 128
        enableNodePublicIP: false
        enableEncryptionAtHost: true
        nodeLabels: {
          workload: 'system'
          tier: 'system-services'
        }
      }
    ]

    // ===================================================
    // NETWORK CONFIGURATION
    // ===================================================
    networkProfile: {
      networkPlugin: 'azure'
      networkPolicy: 'azure'
      loadBalancerSku: 'standard'
      outboundType: 'loadBalancer'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
    }

    // ===================================================
    // AKS ADDONS
    // ===================================================
    addonProfiles: {
      // Azure Policy
      azurePolicy: {
        enabled: true
      }

      // Azure Key Vault CSI Driver
      azureKeyvaultSecretsProvider: {
        enabled: true
        config: {
          enableSecretRotation: 'true'
          rotationPollInterval: '2m'
        }
      }

      // Container Insights
      omsagent: {
        enabled: !empty(logAnalyticsWorkspaceId)
        config: {
          logAnalyticsWorkspaceResourceID: logAnalyticsWorkspaceId
        }
      }
    }

    // ===================================================
    // UPGRADE SETTINGS
    // ===================================================
    autoUpgradeProfile: {
      upgradeChannel: 'stable'
    }

    // ===================================================
    // WORKLOAD IDENTITY
    // ===================================================
    securityProfile: {
      workloadIdentity: {
        enabled: true
      }
    }
  }
}

// =======================================================
// MAINTENANCE WINDOW
// =======================================================

resource aksMaintenance 'Microsoft.ContainerService/managedClusters/maintenanceConfigurations@2024-01-01' = {
  parent: aks
  name: 'default'
  properties: {
    maintenanceWindow: {
      schedule: {
        weekly: {
          dayOfWeek: 'Sunday'
          intervalWeeks: 1
        }
      }
      durationHours: 4
      startTime: '02:00'
      utcOffset: '+00:00'
    }
  }
}

// =======================================================
// OUTPUTS
// =======================================================

@description('AKS Resource ID')
output aksId string = aks.id

@description('AKS Cluster Name')
output aksName string = aks.name

@description('AKS Control Plane Identity Principal ID')
output controlPlanePrincipalId string = aksIdentity.properties.principalId

@description('AKS Kubelet Identity Object ID')
output kubeletObjectId string = aks.properties.identityProfile.kubeletidentity.objectId

@description('AKS Kubelet Identity Client ID')
output kubeletClientId string = aks.properties.identityProfile.kubeletidentity.clientId

@description('OIDC Issuer URL')
output oidcIssuerUrl string = aks.properties.oidcIssuerProfile.issuerUrl
