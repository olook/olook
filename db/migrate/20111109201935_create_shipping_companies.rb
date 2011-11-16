class CreateShippingCompanies < ActiveRecord::Migration
  def change
    create_table :shipping_companies do |t|
      t.string :name
      t.string :erp_code

      t.timestamps
    end
  end
end
