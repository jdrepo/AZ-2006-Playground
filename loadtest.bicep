
// loadtest.bicep
@description('Name of the Azure Load Testing resource')
param loadTestName string

@description('Azure region')
param location string = resourceGroup().location

// Minimal resource: Microsoft.LoadTestService/loadTests
resource loadTest 'Microsoft.LoadTestService/loadTests@2024-12-01-preview' = {
  name: loadTestName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    // Optional description
    description: 'Load testing instance deployed with Bicep'
    // encryption: {}  // see the CMK example further below
  }
  tags: {
    'workload': 'perf-tests'
  }
}

output loadTestId string = loadTest.id
output loadTestName string = loadTest.name
