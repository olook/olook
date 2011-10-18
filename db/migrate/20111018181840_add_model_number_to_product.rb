class AddModelNumberToProduct < ActiveRecord::Migration
  def change
    add_column :products, :model_number, :string
  end
end
