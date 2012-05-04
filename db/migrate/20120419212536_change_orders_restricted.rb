class ChangeOrdersRestricted < ActiveRecord::Migration
  def up
    change_column :orders, :restricted, :boolean, :default => 0, :null => false
  end

  def down
    change_column :orders, :restricted, :boolean
  end
end
