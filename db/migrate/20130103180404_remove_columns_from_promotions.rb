class RemoveColumnsFromPromotions < ActiveRecord::Migration
  def up
    remove_column :promotions, :param, :priority, :strategy, :discount_percent
  end

  def down
    add_column :promotions, :param, :string
    add_column :promotions, :priority, :integer
    add_column :promotions, :strategy, :string
    add_column :promotions, :discount_percent, :integer
  end
end
