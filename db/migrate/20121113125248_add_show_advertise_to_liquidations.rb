class AddShowAdvertiseToLiquidations < ActiveRecord::Migration
  def change
    add_column :liquidations, :show_advertise, :boolean, :default => true
    add_column :liquidations, :big_banner, :string
  end
end
