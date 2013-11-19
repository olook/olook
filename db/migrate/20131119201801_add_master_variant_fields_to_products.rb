class AddMasterVariantFieldsToProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.decimal  "price",             :precision => 10, :scale => 2
      t.decimal  "width",             :precision => 8,  :scale => 2
      t.decimal  "height",            :precision => 8,  :scale => 2
      t.decimal  "length",            :precision => 8,  :scale => 2
      t.decimal  "weight",            :precision => 8,  :scale => 2
      t.decimal  "retail_price",      :precision => 10, :scale => 2
    end
  end
end
