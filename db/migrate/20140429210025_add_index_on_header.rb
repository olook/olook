class AddIndexOnHeader < ActiveRecord::Migration
  def up
    add_index :headers, :url
  end

  def down
    remove_index :headers, :url
  end
end
