# frozen_string_literal: true

require 'azurerm_resource'

class AzureMonitorActivityLogAlerts < AzurermResource
  name 'azure_monitor_activity_log_alerts'
  desc 'Verifies settings for Azure Monitor Activity Log Alerts'
  example <<-EXAMPLE
    describe azure_monitor_activity_log_alerts do
      its('names') { should include('example-log-alert') }
    end
  EXAMPLE

  attr_reader :table

  FilterTable.create
             .add_accessor(:entries)
             .add_accessor(:where)
             .add(:exists?) { |obj| !obj.entries.empty? }
             .add(:names, field: 'name')
             .add(:resource_group, field: 'resource_group')
             .add(:operations, field: 'operations')
             .connect(self, :table)

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
