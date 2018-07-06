# frozen_string_literal: true

require 'azurerm_resource'

class AzureResourceGroups < AzurermPluralResource
  name 'azure_resource_groups'
  desc 'Fetches all available resource groups'
  example <<-EXAMPLE
    describe azure_resource_groups do
      its('names') { should include('example-group') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  def to_s
    'Resource Groups'
  end

  def table
    @table ||= client.resource_groups
  end
end
