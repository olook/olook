class AddIsDebitToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :is_debit, :boolean, :default => false
  end
end
