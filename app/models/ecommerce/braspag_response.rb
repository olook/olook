class BraspagResponse < ActiveRecord::Base
  def self.column_names
    ["correlation_id", "success", "error_code", "error_message", "processed", "created_at", "updated_at"]
  end
end
