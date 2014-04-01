class AddPageDescriptionToHeaders < ActiveRecord::Migration
  def change
    add_column :headers, :page_description, :string
  end
end
