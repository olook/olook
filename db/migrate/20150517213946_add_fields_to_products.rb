class AddFieldsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :fiscal_classification, :string
    add_column :products, :barcode, :string
    add_column :products, :product_origin, :string
  end
end
