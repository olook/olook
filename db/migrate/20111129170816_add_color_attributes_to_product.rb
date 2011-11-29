class AddColorAttributesToProduct < ActiveRecord::Migration
  def change
    add_column :products, :color_name, :string
    add_column :products, :color_code, :string
  end
end
