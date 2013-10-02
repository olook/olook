class AddProductIdToConsolidatedSells < ActiveRecord::Migration
  def change
    add_column :consolidated_sells, :product_id, :integer
  end
end
