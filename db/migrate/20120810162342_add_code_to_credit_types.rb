class AddCodeToCreditTypes < ActiveRecord::Migration
  def change
    add_column :credit_types, :code, :string
    add_index :credit_types, :code, :unique => true
  end
end
