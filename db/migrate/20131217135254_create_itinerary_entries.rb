class CreateItineraryEntries < ActiveRecord::Migration
  def change
    create_table :itinerary_entries do |t|
      t.integer :itinerary_id
      t.string :when_date
      t.string :where

      t.timestamps
    end
  end
end
