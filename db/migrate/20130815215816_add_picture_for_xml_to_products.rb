class AddPictureForXmlToProducts < ActiveRecord::Migration
  def change
    add_column :products, :picture_for_xml, :string
  end
end
