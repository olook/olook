class AddCreditCardTokenToBraspagResponse < ActiveRecord::Migration
  def change
    add_column :braspag_responses, :credit_card_token, :string

  end
end
