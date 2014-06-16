class CreateProductInterests < ActiveRecord::Migration
  def change
    create_table :product_interests do |t|
      t.integer :campaign_email_id
      t.integer :product_id

      t.timestamps
    end
  end
end
