class AddNewNameToProfile < ActiveRecord::Migration
  def change
  	add_column :profiles, :alternative_name, :string
  end
end
