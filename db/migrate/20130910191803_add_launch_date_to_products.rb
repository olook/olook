class AddLaunchDateToProducts < ActiveRecord::Migration
  def change
    add_column :products, :launch_date, :date
  end
end
