class AddBrandToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :brand, :string

  end
end
