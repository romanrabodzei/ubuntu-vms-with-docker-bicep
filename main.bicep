targetScope = 'subscription'

param location string = deployment().location
param vmAdmin string = 'azureadmin'
@secure()
param vmPassword string
param amount int

var resourceGroupName = 'az-ddos-${location}-rg'

resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module vnet 'modules/vnet.bicep' = {
  scope: resourceGroup
  name: 'vnet'
  params: {
    location: location 
  }
}

module vm 'modules/vm.bicep' = [for i in range(0, amount): {
  scope: resourceGroup
  name: 'vm-${i}'
  params: {
    location: location
    vmName: 'vm-${location}-${i}'
    subnetId: vnet.outputs.vnet
    adminUsername: vmAdmin
    adminPassword: vmPassword
  }
}]
