class CreateLookbooksProducts < ActiveRecord::Migration
  def self.up
      create_table :lookbooks_products do |t|
        t.references :lookbook
        t.references :product
        t.boolean :criteo, :default => false
        t.timestamps
      end
    end

    def self.down
      drop_table :lookbooks_products
  end
end
