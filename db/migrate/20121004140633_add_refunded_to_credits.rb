class AddRefundedToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :refunded, :boolean, :default => false

  end
end
