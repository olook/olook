class AddColumnsToPromotions < ActiveRecord::Migration
  def change
    add_column :promotions, :starts_at, :date
    add_column :promotions, :ends_at, :date
  end
end
