class ChangeZipStartAndZipEndInShippings < ActiveRecord::Migration
  def change
    change_column :shippings, :zip_start, :integer
    change_column :shippings, :zip_end, :integer
  end
end
