class CreateProductsProfiles < ActiveRecord::Migration
  def change
    create_table :products_profiles, :id => false do |t|
      t.references :product
      t.references :profile

      t.timestamps
    end
  end
end
