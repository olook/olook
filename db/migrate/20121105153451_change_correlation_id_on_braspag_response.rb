class ChangeCorrelationIdOnBraspagResponse < ActiveRecord::Migration

    def self.table_exists?(braspag_responses)
      change_column :braspag_responses, :correlation_id, :string
    end
end

