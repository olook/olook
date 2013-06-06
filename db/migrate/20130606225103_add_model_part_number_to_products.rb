class AddModelPartNumberToProducts < ActiveRecord::Migration
  def change
    add_column :products, :model_part_number, :string
  end
end
