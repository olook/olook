class AddProcessedToClearsaleOrderResponses < ActiveRecord::Migration
  def change
    add_column :clearsale_order_responses, :processed, :boolean, :default => false

  end
end
