class CreateGiftOccasionTypes < ActiveRecord::Migration
  def change
    create_table :gift_occasion_types do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
