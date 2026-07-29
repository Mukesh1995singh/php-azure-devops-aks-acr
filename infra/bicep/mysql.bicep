// =======================================================
// MYSQL FLEXIBLE SERVER MODULE
// Production Ready for AKS Workloads
// Private Network + HA + Backup + SSL
// =======================================================

// =======================================================
// PARAMETERS
// =======================================================

@description('Azure region where MySQL will be deployed')
param location string = resourceGroup().location

@description('MySQL Flexible Server name')
param mysqlServerName string

@description('Application database name')
param databaseName string = 'phpappdb'

@description('Administrator username')
param administratorLogin string = 'mysqladmin'

@secure()
@description('Administrator password from Key Vault')
param administratorLoginPassword string

@description('MySQL version')
@allowed([
  '8.0'
])
param mysqlVersion string = '8.0'

@description('SKU Tier')
@allowed([
  'Burstable'
  'GeneralPurpose'
  'MemoryOptimized'
])
param skuTier string = 'GeneralPurpose'

@description('SKU Name')
param skuName string = 'Standard_D2ds_v4'

@description('High Availability Mode')
@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
param highAvailabilityMode string = 'ZoneRedundant'

@description('Storage size GB')
param storageSizeGB int = 32

@description('Storage auto growth')
@allowed([
  'Enabled'
  'Disabled'
])
param storageAutoGrow string = 'Enabled'

@description('Backup retention days')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 35

@description('Geo redundant backup')
@allowed([
  'Enabled'
  'Disabled'
])
param geoRedundantBackup string = 'Enabled'

@description('Public network access')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Delegated subnet resource ID')
param delegatedSubnetResourceId string

@description('Private DNS Zone Resource ID')
param privateDnsZoneArmResourceId string

@description('Enable SSL enforcement')
param enableSslEnforcement bool = true

@description('Tags')
param tags object = {
  Environment: 'Production'
  Project: 'AKS-CICD'
}

// =======================================================
// MYSQL FLEXIBLE SERVER
// =======================================================

resource mysqlServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: mysqlServerName
  location: location
  tags: tags

  sku: {
    name: skuName
    tier: skuTier
  }

  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: mysqlVersion

    // Storage Configuration
    storage: {
      storageSizeGB: storageSizeGB
      autoGrow: storageAutoGrow
    }

    // Backup Configuration
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }

    // High Availability
    highAvailability: {
      mode: highAvailabilityMode
    }

    // Private Network Configuration
    network: {
      publicNetworkAccess: publicNetworkAccess
      delegatedSubnetResourceId: delegatedSubnetResourceId
      privateDnsZoneArmResourceId: privateDnsZoneArmResourceId
    }

    // Maintenance Window
    maintenanceWindow: {
      customWindow: 'Enabled'
      startHour: 2
      startMinute: 0
      dayOfWeek: 0
    }
  }
}

// =======================================================
// SSL CONFIGURATION
// =======================================================

resource sslConfiguration 'Microsoft.DBforMySQL/flexibleServers/configurations@2023-12-30' = if (enableSslEnforcement) {
  parent: mysqlServer
  name: 'require_secure_transport'
  properties: {
    value: 'ON'
    source: 'user-override'
  }
}

// =======================================================
// DATABASE
// =======================================================

resource applicationDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2023-12-30' = {
  parent: mysqlServer
  name: databaseName
  properties: {
    charset: 'utf8mb4'
    collation: 'utf8mb4_unicode_ci'
  }
}

// =======================================================
// OUTPUTS
// =======================================================

@description('MySQL Server ID')
output mysqlServerId string = mysqlServer.id

@description('MySQL Server Name')
output mysqlServerName string = mysqlServer.name

@description('MySQL FQDN')
output mysqlFqdn string = mysqlServer.properties.fullyQualifiedDomainName

@description('Database Name')
output databaseName string = applicationDatabase.name

@description('MySQL Host')
output mysqlHost string = mysqlServer.properties.fullyQualifiedDomainName

@description('MySQL Port')
output mysqlPort string = '3306'

@description('SSL Enabled')
output sslEnabled bool = enableSslEnforcement
