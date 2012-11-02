class AddLineItemIdToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :line_item_id, :integer
	add_index :credits, :line_item_id
  end
end
