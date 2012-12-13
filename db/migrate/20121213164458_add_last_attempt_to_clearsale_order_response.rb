class AddLastAttemptToClearsaleOrderResponse < ActiveRecord::Migration
  
  def change
    add_column :clearsale_order_responses, :last_attempt, :datetime
  end
  
end
