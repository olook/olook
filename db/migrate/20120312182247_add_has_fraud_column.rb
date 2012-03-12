class AddHasFraudColumn < ActiveRecord::Migration
  def change
    add_column :users, :has_fraud, :boolean
  end
end
