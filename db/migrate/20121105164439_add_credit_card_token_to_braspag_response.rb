class AddCreditCardTokenToBraspagResponse < ActiveRecord::Migration
  def self.table_exists?(braspag_responses)
    add_column :braspag_responses, :credit_card_token, :string
  end
end
