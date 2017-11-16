
# Declare attributes that should be used when running these controls
SA_RESOURCE_GROUP_NAME = attribute(
  'sa_resource_group_name',
  default: '',
  description: 'Name of the resource group that contains the resource being tested',
)

SA_NAME = attribute(
  'sa_name',
  desfault: '',
  description: 'Name of the storage account being tested',
)

title 'Azure Storage Accounts'

control 'cis-azure-benchmark-3.1' do
  impact 1.0
  title "Ensure that 'Secure transfer required' is set to Enabled"
  desc 'Enable data encryption is transit.'

  tag cis: 'azure-3.1'
  tag level: 1

  describe azure_generic_resource(group_name: SA_RESOURCE_GROUP_NAME, name: SA_NAME) do
    its('properties.supportsHttpsTrafficOnly') { should be true }
  end
end

control 'cis-azure-benchmark-3.2' do
  impact 1.0
  title "Ensure that 'Storage service encryption' is set to Enabled for Blob Service"
  desc 'Enable data encryption at rest for blobs.'

  tag cis: 'azure-3.2'
  tag level: 1

  describe azure_generic_resource(group_name: SA_RESOURCE_GROUP_NAME, name: SA_NAME) do
    its('properties.encryption.services.blob.enabled') { should be true }
  end
end

control 'cis-azure-benchmark-3.6' do
  impact 1.0
  title "Ensure that 'Storage service encryption' is set to Enabled for File Service"
  desc 'Enable data encryption at rest for file service.'

  tag cis: 'azure-3.6'
  tag level: 1

  describe azure_generic_resource(group_name: SA_RESOURCE_GROUP_NAME, name: SA_NAME) do
    its('properties.encryption.services.file.enabled') { should be true }
  end
end
