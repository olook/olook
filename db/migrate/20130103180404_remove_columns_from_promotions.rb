class RemoveColumnsFromPromotions < ActiveRecord::Migration
  def up
    remove_column :promotions, :param, :priority, :strategy, :discount_percent
  end

  def down
    add_column :promotions, :param, :priority, :strategy, :discount_percent
  end
end
