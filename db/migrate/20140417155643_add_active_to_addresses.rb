class AddActiveToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :active, :boolean, default: true
  end
end
