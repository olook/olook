class AddAltToClippings < ActiveRecord::Migration
  def change
    add_column :clippings, :alt, :string
  end
end
