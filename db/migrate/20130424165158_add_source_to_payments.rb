class AddSourceToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :source, :string
  end
end
