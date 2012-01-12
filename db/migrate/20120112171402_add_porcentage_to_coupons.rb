class AddPorcentageToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :is_percentage, :boolean
  end
end
