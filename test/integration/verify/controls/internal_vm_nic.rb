title 'Internal VM Network Interface Card'

control 'azure-vm-internal-nic-2.0' do

  impact 1.0
  title 'Ensure that the NIC for the internal VM is correctly setup'

  # Ensure that the virtual machine has been created with the correct attributes
  describe azure_resource(group_name: 'Inspec-Azure',
                          name: 'Inspec-NIC-1') do

    # There should be no tags
    its('tags.count') { should eq 0 } 
  
    # The resources should be a network interface
    its('type') { should cmp 'Microsoft.Network/networkInterfaces' }

    # It should have only 1 ipConfiguration
    its('properties.ipConfigurations.count') { should eq 1 }

    # Ensure that the NIC is setup correctly
    describe described_class.properties.ipConfigurations.first do
      its('name') { should cmp 'ipConfiguration1' }
      its('properties.privateIPAddress') { should cmp '10.1.1.10' }
      its('properties.privateIPAllocationMethod') { should cmp 'Static' }

      # Ensure that it is connected to the correct subnet
      its('properties.subnet.id') { should match 'Inspec-Subnet' }
    end

    # There should be no custom dns settings
    its('properties.dnsSettings.dnsServers.count') { should eq 0 }
    its('properties.dnsSettings.appliedDnsServers.count') { should eq 0 }

    # This NIC should be connected to the correct machine
    its('properties.virtualMachine.id') { should match 'Linux-Internal-VM' }

    its('properties.enableAcceleratedNetworking') { should be false }
    its('properties.enableIPForwarding') { should be false }
  end
end