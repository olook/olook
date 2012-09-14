class MoveAddressFieldsToFreight < ActiveRecord::Migration
  def change
    change_table :freights do |t|
      t.column  "country", :string
      t.column  "city", :string
      t.column  "state", :string
      t.column  "complement", :string
      t.column  "street", :string
      t.column  "number", :string
      t.column  "neighborhood", :string
      t.column  "zip_code", :string
      t.column  "telephone", :string
    end

    remove_column :orders, :user_address
    remove_column :orders, :user_telephone
  end
end