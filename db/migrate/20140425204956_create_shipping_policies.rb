class CreateShippingPolicies < ActiveRecord::Migration
  def change
    create_table :shipping_policies do |t|
      t.string :zip_start
      t.string :zip_end
      t.string :value_start
      t.string :value_end

      t.timestamps
    end
  end
end
