targetScope = 'resourceGroup'

param personalPublicIP string
param location string

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: '${location}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-ssh'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: personalPublicIP
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

output nsgId string = nsg.id
