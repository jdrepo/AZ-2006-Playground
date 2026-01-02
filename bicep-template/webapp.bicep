param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param sku string = 'S1' // The SKU of App Service Plan
param location string = resourceGroup().location
param slotName string = 'staging'
param configurationSource string = 'production'

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
}
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}


/* =========================
   Deployment Slot
   ========================= */
resource slot 'Microsoft.Web/sites/slots@2022-09-01' = {
  name: '${webAppName}/${slotName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    // httpsOnly: true
    configurationSource: configurationSource // 'production' clones the main site's config
    /* siteConfig: {
      linuxFxVersion: osType == 'Linux' ? linuxFxVersion : ''
      alwaysOn: true
      http20Enabled: true
      ftpsState: 'Disabled'
    } */
  }
}

