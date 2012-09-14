class AddUserCreditToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :user_credit_id, :integer
    add_index :credits, :user_credit_id
  end
end
