# frozen_string_literal: true

require 'azurerm_resource'

class AzureMonitorLogProfiles < AzurermPluralResource
  name 'azure_monitor_log_profiles'
  desc 'Fetches all Azure Monitor Log Profiles'
  example <<-EXAMPLE
    describe azure_monitor_log_profiles do
      its('names') { should include('example-profile') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  def to_s
    'Log Profiles'
  end

  def table
    @table ||= client.log_profiles
  end
end
