targetScope = 'resourceGroup'

param location string

param vmName string

param subnetId string
param adminUsername string
param adminPassword string


resource pip 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: '${vmName}-pip'
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
    idleTimeoutInMinutes: 4
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: pip.id
          }
          subnet: {
            id: subnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-focal'
        sku: '20_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        osType: 'Linux'
        name: '${vmName}-disk'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
    }
    osProfile: {
      computerName: replace(vmName, '-', '')
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
  }
  resource customScript 'extensions' = {
    name: '${vmName}-ext'
    location: location
    properties: {
      publisher: 'Microsoft.Azure.Extensions'
      type: 'CustomScript'
      typeHandlerVersion: '2.0'
      autoUpgradeMinorVersion: true
      settings: {
        commandToExecute: 'sh install_docker.sh'
        fileUris: [
          'https://raw.githubusercontent.com/romanrabodzei/ubuntu-vms-with-docker-bicep/main/install_docker.sh'
        ]
      }
    }
  }
}
