# frozen_string_literal: true

require 'azurerm_resource'

class AzureMonitorActivityLogAlerts < AzurermPluralResource
  name 'azure_monitor_activity_log_alerts'
  desc 'Verifies settings for Azure Monitor Activity Log Alerts'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:names, field: 'name')
             .register_column(:resource_group, field: 'resource_group')
             .register_column(:operations, field: 'operations')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize
    resp = client.activity_log_alerts
    return if resp.nil? || (resp.is_a?(Hash) && resp.key?('error'))

    @table = resp.collect(&with_resource_group)
                 .collect(&with_operations)
  end

  def to_s
    'Activity Log Alerts'
  end

  def with_resource_group
    lambda do |group|
      # Get resource group from ID string
      name = group['id'].split('/')[4]
      group.merge('resource_group' => name)
    end
  end

  def with_operations
    lambda do |alert|
      operation_name = ->(o) { o['field'] == 'operationName' }
      equals         = ->(o) { o['equals'] }

      conditions = alert.dig('properties', 'condition', 'allOf')

      alert.merge('operations' => conditions.select(&operation_name).collect(&equals))
    end
  end
end
