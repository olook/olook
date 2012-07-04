class CreateTimelineTracks < ActiveRecord::Migration
  def change
    create_table :timeline_tracks do |t|
      t.integer :order_id
      t.text :timeline
      t.timestamps
    end
  end
end
