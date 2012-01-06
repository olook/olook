class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.decimal :value, :precision => 8, :scale => 2
      t.integer :remaining_amount
      t.boolean :unlimited
      t.boolean :active
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
