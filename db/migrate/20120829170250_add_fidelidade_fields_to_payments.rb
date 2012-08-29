class AddFidelidadeFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :credit_type_id, :integer

    add_column :payments, :credit_ids, :text

    add_index :payments, :credit_type_id
  end
end
