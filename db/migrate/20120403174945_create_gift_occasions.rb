class CreateGiftOccasions < ActiveRecord::Migration
  def change
    create_table :gift_occasions do |t|
      t.references :user
      t.references :gift_recipient
      t.references :gift_occasion_type
      t.integer :day
      t.integer :month
      t.timestamps
    end
  end
end
