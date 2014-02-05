class CreateAdminItineraries < ActiveRecord::Migration
  def change
    create_table :itineraries do |t|
      t.string :name

      t.timestamps
    end
  end
end
