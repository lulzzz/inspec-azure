# frozen_string_literal: true

require 'azurerm_resource'

class AzureNetworkSecurityGroups < AzurermPluralResource
  name 'azure_network_security_groups'
  desc 'Verifies settings for Network Security Groups'
  example <<-EXAMPLE
    azure_network_security_groups(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = client.network_security_groups(resource_group)
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp
  end

  def to_s
    'Network Security Groups'
  end
end
