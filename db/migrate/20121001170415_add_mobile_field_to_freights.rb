class AddMobileFieldToFreights < ActiveRecord::Migration
  def change
	add_column :freights, :mobile, :string
  end
end
