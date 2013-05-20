class AddModalToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :modal, :string
  end
end
