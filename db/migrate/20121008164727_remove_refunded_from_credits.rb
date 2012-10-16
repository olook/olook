class RemoveRefundedFromCredits < ActiveRecord::Migration
  def up
    remove_column :credits, :refunded
      end

  def down
    add_column :credits, :refunded, :boolean
  end
end
