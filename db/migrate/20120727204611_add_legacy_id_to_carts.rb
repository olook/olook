class AddLegacyIdToCarts < ActiveRecord::Migration
  def change
  	add_column :carts, :legacy_id, :integer
  end
end
