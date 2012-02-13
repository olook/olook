class AddSlugToLookbooks < ActiveRecord::Migration
  def change
    add_column :lookbooks, :slug, :string
  end
end
