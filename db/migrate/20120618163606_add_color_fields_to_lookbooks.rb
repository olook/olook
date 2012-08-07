class AddColorFieldsToLookbooks < ActiveRecord::Migration
  def change
    add_column :lookbooks, :fg_color, :string
    add_column :lookbooks, :bg_color, :string
  end
end
