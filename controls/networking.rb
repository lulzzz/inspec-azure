
# Declare attributes that should be used when running these controls
NSG_RESOURCE_GROUP_NAME = attribute(
  'nsg_resource_group_name',
  default: '',
  description: 'Name of the resource group that contains the resource being tested',
)

NSG_NAME = attribute(
  'nsg_name',
  desfault: '',
  description: 'Name of the network security group to being tested',
)

# Define array that states where the tarffic is coming from
# Both denote access from the Internet
sources = ['*', 'Internet']

title 'Azure Networking'

control 'cis-azure-benchmark-6.1' do
  impact 1.0
  title 'Disable RDP access on Network Security Groups from Internet'

  tag cis: 'azure-6.1'
  tag level: 1

  # Attempt to find rule that allows RDP access from the Interner
  nsg_rule = azure_generic_resource(group_name: NSG_RESOURCE_GROUP_NAME, name: NSG_NAME)
                       .properties.securityRules.find { |r| r.properties.destinationPortRange == '3389' && !sources.include?(r.properties.sourceAddressPrefix) }

  describe nsg_rule do
    it { should be nil }
  end
end

control 'cis-azure-benchmark-6.2' do
  impact 1.0
  title 'Disable SSH access on Network Security Groups from Internet'

  tag cis: 'azure-6.2'
  tag level: 1

  # Attempt to find rule that allows RDP access from the Interner
  nsg_rule = azure_generic_resource(group_name: NSG_RESOURCE_GROUP_NAME, name: NSG_NAME)
                       .properties.securityRules.find { |r| r.properties.destinationPortRange == '22' && sources.include?(r.properties.sourceAddressPrefix) }

  describe nsg_rule do
    it { should be nil }
  end
end
