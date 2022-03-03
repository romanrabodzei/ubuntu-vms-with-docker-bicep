targetScope = 'resourceGroup'

param location string

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: '${location}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/16'
        }
      }
    ]
  }
}

output vnet string = vnet.properties.subnets[0].id
