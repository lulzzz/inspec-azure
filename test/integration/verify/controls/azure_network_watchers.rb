resource_group = attribute('resource_group', default: nil)

control 'azure_network_watchers' do
  only_if { ENV['ENABLE_NETWORK_WATCHER'] }

  describe azure_network_watchers(resource_group: resource_group) do
    it           { should exist }
    its('names') { should be_an(Array) }
  end
end
