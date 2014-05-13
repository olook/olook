class RemoveTextComplementFromHeaders < ActiveRecord::Migration
  def up
    remove_column :headers, :text_complement
  end

  def down
    add_column :headers, :text_complement, :string
  end
end
