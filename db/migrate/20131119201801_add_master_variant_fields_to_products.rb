class AddMasterVariantFieldsToProducts < ActiveRecord::Migration
  def up
    change_table :products do |t|
      t.decimal  "price",             :precision => 10, :scale => 2
      t.decimal  "width",             :precision => 8,  :scale => 2
      t.decimal  "height",            :precision => 8,  :scale => 2
      t.decimal  "length",            :precision => 8,  :scale => 2
      t.decimal  "weight",            :precision => 8,  :scale => 2
      t.decimal  "retail_price",      :precision => 10, :scale => 2
      t.integer  "discount_percent"
    end
    execute("update products p join variants v on v.product_id = p.id and v.is_master = 1 set p.price = v.price, p.retail_price = IF(v.retail_price > 0, v.retail_price, v.price), p.weight = v.weight, p.height = v.height, p.length = v.length, p.width = v.width, p.discount_percent = v.discount_percent;")
  end

  def down
    change_table :products do |t|
      t.remove  "price"
      t.remove  "width"
      t.remove  "height"
      t.remove  "length"
      t.remove  "weight"
      t.remove  "retail_price"
      t.remove  "discount_percent"
    end
  end
end
